require 'rails_helper'

RSpec.describe "Weather", type: :request do
  let(:address_params) { { city: 'Dallas', state: 'TX', zip_code: '75201' } }
  let(:geocoder_data) { Location.new(lat: 32.7767, lon: -96.7970, zip_code: '75201') }
  let(:weather_data) do
    OpenStruct.new(
      temperature: 75,
      conditions: "Clear",
      condition_id: 800,
      humidity: 50,
      wind_speed: 5.0
    )
  end
  before do
    allow(OpenWeather::Geocoder).to receive(:new).and_return(geocoder)
    allow(geocoder).to receive(:fetch).and_return(geocoder_data)
  end

  describe "GET /weather" do
    context "when geocoding is successful" do
      let(:geocoder) { instance_double(OpenWeather::Geocoder, error?: false) }

      before do
        allow(OpenWeather::Weather).to receive(:fetch).and_return(weather_data)
      end

      it "caches the weather data if not cached" do
        expect(Rails.cache).to receive(:write)
        get weather_path, params: address_params
      end
    end

    context "when geocoding fails" do
      let(:geocoder) { instance_double(OpenWeather::Geocoder, error?: true, error_messages: "Geocoding failed") }

      it "redirects to new_address_path with an error message" do
        get weather_path, params: address_params

        expect(response).to redirect_to(new_address_path)
        expect(flash[:alert]).to eq("Geocoding failed")
      end
    end

    context "when the location is nil" do
      let(:geocoder) { instance_double(OpenWeather::Geocoder, error?: false) }

      before do
        allow(geocoder).to receive(:fetch).and_return(nil)
      end

      it "redirects to new_address_path with an error message" do
        get weather_path, params: address_params

        expect(response).to redirect_to(new_address_path)
        expect(flash[:alert]).to eq("Unable to geocode address")
      end
    end

    context "when weather data is cached" do
      let(:geocoder) { instance_double(OpenWeather::Geocoder, error?: false) }

      before do
        Rails.cache.write('75201', weather_data)
      end

      it "fetches weather data from the cache" do
        get weather_path, params: address_params

        expect(assigns(:response)).to be_a(OpenWeather::Response)
        expect(assigns(:cached)).to be(true)
      end
    end
  end
end
