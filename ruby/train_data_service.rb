require 'httparty'
require 'json'
require_relative 'reservations.rb'

class TrainDataService
  include HTTParty
  base_uri 'http://localhost:8081'

  def next_available_seat
    # TODO: test and implement
    coach = seat_plan["seats"].values[0]["coach"]
    seat_number = seat_plan["seats"].values[0]["seat_number"]
    Seat.new(coach, seat_number)
  end

  private

  def seat_plan
    response = self.class.get('/data_for_train/express_2000')
    JSON.parse!(response.body)
  end
end
