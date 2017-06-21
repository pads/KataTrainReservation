require 'httparty'
require 'json'
require 'uri'
require_relative 'reservations.rb'

class TrainDataService
  include HTTParty
  base_uri 'http://localhost:8081'

  def next_available_seat
    # TODO: test
    seat_plan["seats"].keys.each do |seat|
      next unless seat_plan["seats"][seat]["booking_reference"].empty?
      @coach = seat_plan["seats"][seat]["coach"]
      @seat_number = seat_plan["seats"][seat]["seat_number"]
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
