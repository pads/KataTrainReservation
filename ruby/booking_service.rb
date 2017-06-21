require 'httparty'

class BookingService
  include HTTParty
  base_uri 'http://localhost:8082'

  def generate_reference
    response = self.class.get('/booking_reference')
    response.body
  end
end
