require 'httparty'
require 'json'
require 'uri'
require_relative 'reservations.rb'

class TrainDataService
  include HTTParty
  base_uri 'http://localhost:8081'

  def initialize(train_capacity = 0.7)
    @train_capacity = 0.7 # i.e 70%
  end

  def next_available_seat
    # TODO: test
    @current_seat_plan ||= seat_plan["seats"]
    total_seats = @current_seat_plan.size
    max_seats = (total_seats * @train_capacity).to_i
    total_booked = @current_seat_plan.select do |seat|
      !@current_seat_plan[seat]["booking_reference"].empty?
    end.size

    puts "Max seats that can be booked: #{max_seats}"
    puts "Total booked thus far: #{total_booked}"

    return if total_booked >= max_seats
    puts "Still under capacity, proceeding with reservation..."

    sorted_keys = @current_seat_plan.keys.sort do |first, second|
      first.reverse <=> second.reverse
    end

    puts sorted_keys

    sorted_keys.each do |seat|
      next unless @current_seat_plan[seat]["booking_reference"].empty?
      @coach = @current_seat_plan[seat]["coach"]
      @seat_number = @current_seat_plan[seat]["seat_number"]
      @current_seat_plan[seat]["booking_reference"] = "hold"
      break
    end
    Seat.new(@coach, @seat_number)
  end

  def reserve_seats(seats, reference)
    response = self.class.post('/reserve', {
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded'
      },
      body: URI.encode_www_form([
        ['train_id', 'express_2000'],
        ['seats', seats.map(&:to_s).to_s],
        ['booking_reference', reference]
      ])
    })
  end

  private

  def seat_plan
    response = self.class.get('/data_for_train/express_2000')
    JSON.parse!(response.body)
  end
end
