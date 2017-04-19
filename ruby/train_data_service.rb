require_relative 'reservations.rb'

class TrainDataService
  def next_available_seat
    # TODO: test and implement
    Seat.new('A', 1)
  end
end
