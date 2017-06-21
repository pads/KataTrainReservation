
# Deploy as a web service using Sinatra
# before you'll be able to run this you'll need 'gem install sinatra'

require 'sinatra'
require 'json'
require 'uri'

require_relative 'ticket_office.rb'
require_relative 'train_data_service.rb'
require_relative 'booking_service.rb'

post '/reserve' do
  train_data_service = TrainDataService.new
  booking_service = BookingService.new
  office = TicketOffice.new(train_data_service, booking_service)
  input = URI.decode_www_form(request.body.read)
  # input[0][1] = train_id
  # input[1][1] = number of seats
  reservation_request = ReservationRequest.new(input[0][1], input[1][1].to_i)
  reservation = office.make_reservation reservation_request
  respond_with reservation
end

configure do
  set :port, '8083'
end

def respond_with(reservation)
  {
    train_id: reservation.train_id,
    booking_reference: reservation.booking_reference,
    seats: reservation.seats.map {|seat| "#{seat.number}#{seat.coach}" }
  }.to_json
end
