require_relative 'reservations.rb'

class TicketOffice

  def initialize(train_data_service, booking_service)
    @train_data_service = train_data_service
    @booking_service = booking_service
  end

  def make_reservation(request)
    seats = []
    request.seat_count.times do
      seat = @train_data_service.next_available_seat
      break unless seat # seat will be nil if there are no more seats available.
      seats << seat
    end
    # We were not able to reserve all the seats so we must abandon the reservation.
    return if seats.size < request.seat_count
    reference = @booking_service.generate_reference
    @train_data_service.reserve_seats(seats, reference)
    Reservation.new(reference, request.train_id, seats)
  end
end
