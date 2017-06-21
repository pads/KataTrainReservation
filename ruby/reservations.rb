class ReservationRequest
  attr_reader :booking_reference
  attr_reader :train_id
  attr_reader :seat_count

  def initialize(train_id, seat_count)
    @train_id = train_id
    @seat_count = seat_count
  end
end

class Reservation
  attr_reader :booking_reference
  attr_reader :train_id
  attr_reader :seats

  def initialize(booking_reference, train_id, seats)
    @booking_reference = booking_reference
    @train_id = train_id
    @seats = seats
  end
end

class Seat
  attr_reader :coach
  attr_reader :number

  def initialize(coach, number)
    @coach = coach
    @number = number
  end

  def to_s
    "#{@number}#{@coach}"
  end
end
