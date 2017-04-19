require 'uri'
require_relative 'reservations.rb'
require_relative 'ticket_office.rb'

describe TicketOffice do
  let(:train_data_service) { double('TrainDataService') }
  let(:booking_service) { double('BookingService') }

  it 'reserves a single seat' do
    reservation_request = ReservationRequest.new('express_2000', 1)

    allow(booking_service).to receive(:generate_reference)

    seat = Seat.new('A', 1)
    allow(train_data_service).to receive(:next_available_seat).and_return(seat)

    office = TicketOffice.new(train_data_service, booking_service)

    reservation = office.make_reservation reservation_request

    expect(reservation.train_id).to eq 'express_2000'
    expect(reservation.seats.size).to be 1
    expect(reservation.seats.first.coach).to eq 'A'
    expect(reservation.seats.first.number).to eq 1
  end

  it 'reserves multiple seats' do
    reservation_request = ReservationRequest.new('express_2000', 2)

    allow(booking_service).to receive(:generate_reference)

    allow(train_data_service)
      .to receive(:next_available_seat).and_return(Seat.new('A', 1), Seat.new('A', 2))

    office = TicketOffice.new(train_data_service, booking_service)

    reservation = office.make_reservation reservation_request

    expect(reservation.seats.size).to be 2
    expect(reservation.seats.first.coach).to eq 'A'
    expect(reservation.seats.first.number).to eq 1
    expect(reservation.seats.last.coach).to eq 'A'
    expect(reservation.seats.last.number).to eq 2
  end

  it 'obtains a booking reference with the reservation' do
    reservation_request = ReservationRequest.new('express_2000', 1)

    allow(booking_service).to receive(:generate_reference).and_return('75bcd1b')

    seat = Seat.new('B', 8)
    allow(train_data_service).to receive(:next_available_seat).and_return(seat)

    office = TicketOffice.new(train_data_service, booking_service)

    reservation = office.make_reservation reservation_request
    expect(reservation.booking_reference).to eq '75bcd1b'
  end
end
