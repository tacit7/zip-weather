# spec/models/location_spec.rb
require 'rails_helper'

RSpec.describe Location, type: :model do
  describe '#initialize' do
    it 'initializes with latitude, longitude, and optional zip code' do
      location = Location.new(lat: 32.7767, lon: -96.7970, zip_code: '75201')

      expect(location.lat).to eq(32.7767)
      expect(location.lon).to eq(-96.7970)
      expect(location.zip_code).to eq('75201')
    end

    it 'initializes without a zip code' do
      location = Location.new(lat: 32.7767, lon: -96.7970)

      expect(location.lat).to eq(32.7767)
      expect(location.lon).to eq(-96.7970)
      expect(location.zip_code).to be_nil
    end
  end

  describe '#==' do
    it 'returns true if latitude and longitude are the same' do
      location1 = Location.new(lat: 32.7767, lon: -96.7970)
      location2 = Location.new(lat: 32.7767, lon: -96.7970)

      expect(location1).to eq(location2)
    end

    it 'returns false if latitude or longitude are different' do
      location1 = Location.new(lat: 32.7767, lon: -96.7970)
      location2 = Location.new(lat: 40.7128, lon: -74.0060)

      expect(location1).not_to eq(location2)
    end
  end

  describe '.from_geocoder_data' do
    it 'builds a Location object from geocoder data' do
      geocoder_data = {
        lat: 32.7767,
        lon: -96.7970,
        zip_code: '75201'
      }

      location = Location.from_geocoder_data(geocoder_data)

      expect(location.lat).to eq(32.7767)
      expect(location.lon).to eq(-96.7970)
      expect(location.zip_code).to eq('75201')
    end

    it 'creates a Location object without a zip code if not provided' do
      geocoder_data = {
        lat: 32.7767,
        lon: -96.7970
      }

      location = Location.from_geocoder_data(geocoder_data)

      expect(location.lat).to eq(32.7767)
      expect(location.lon).to eq(-96.7970)
      expect(location.zip_code).to be_nil
    end
  end
end
