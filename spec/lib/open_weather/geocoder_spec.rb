require 'rails_helper'

RSpec.describe OpenWeather::Geocoder do
  let(:address) { Address.new(city: 'Austin', state: 'TX', country: 'US', zip_code: '78701')  }
  let(:invalid_address) { Address.new(city: 'Austin', state: 'XX', country: 'US', zip_code: 'XXXXX')  }
  let(:location) { Location.new lat: 30.2713, lon: -97.7426, zip_code: '78701' }

  let(:geo_instance) { OpenWeather::Geocoder.new(address) }
  let(:bad_geo_instance) { OpenWeather::Geocoder.new(address) }

  describe '.fetch', :vcr do
    context 'when a valid address is provided' do
      it 'returns latitude and longitude' do
        result = OpenWeather::Geocoder.fetch(address)
        expect(result).to eq(location)
      end
    end

    context 'when an invalid address is provided' do
      it 'returns nil' do
        result = OpenWeather::Geocoder.new(invalid_address).fetch
        expect(result).to be_nil
      end
    end
  end

  describe '#initialize' do
    it 'initializes instance variables to nil' do
      expect(geo_instance.data).to be_nil
    end
  end

  describe '#fetch', :vcr do
    context 'when a valid address is provided' do
      it 'makes an API call and sets data' do
        geo_instance.fetch
        expect(geo_instance.data).not_to be_nil
      end
    end

    context 'when an invalid address is provided' do
      it 'makes an API call and does not set data' do
        bad_geo_instance.fetch
        expect(geo_instance.data).to be_nil
      end
    end
  end

  describe '#query' do
    it 'returns the correct query parameters' do
      expected_query = "https://api.openweathermap.org/geo/1.0/zip?appid=860a43ddc078a76a1d949e68c369ae63&zip=78701%2CUS"
      geo_instance.fetch
      expect(geo_instance.query).to eq(expected_query)
    end
  end

  describe '#data', :vcr do
    context 'after fetching with a valid address' do
      before do
        geo_instance.fetch
      end

      it 'parses the response data' do
        expect(geo_instance.data).to be_a(Hash)
        expect(geo_instance.data.first).to eq([ :zip, "78701" ])
      end
    end

    context 'after fetching with an invalid address' do
      before do
        bad_geo_instance.fetch
      end

      it 'returns nil' do
        expect(geo_instance.data).to be_nil
      end
    end
  end
end
