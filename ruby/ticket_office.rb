require_relative 'reservations.rb'

class TicketOffice

  def initialize(train_data_service, booking_service)
    @train_data_service = train_data_service
    @booking_service = booking_service
  end

  def make_reservation(request)
    seats = []
    request.seat_count.times do |index|
      seats << @train_data_service.next_available_seat
    end
    reference = @booking_service.generate_reference
    @train_data_service.reserve_seats(seats, reference)
    Reservation.new(reference, request.train_id, seats)
  end
end
