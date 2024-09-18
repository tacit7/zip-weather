require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#initialize' do
    it 'initializes with city, state, country, and zip code' do
      address = Address.new(city: 'Dallas', state: 'TX', country: 'US', zip_code: '75201')

      expect(address.city).to eq('Dallas')
      expect(address.state).to eq('TX')
      expect(address.country).to eq('US')
      expect(address.zip_code).to eq('75201')
    end
  end

  describe '#query_format' do
    it 'returns the address formatted for the geolocation API' do
      address = Address.new(city: 'Dallas', state: 'TX', country: 'US', zip_code: '75201')

      expect(address.query_format).to eq('75201,US')
    end
  end
end
