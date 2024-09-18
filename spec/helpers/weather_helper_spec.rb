require 'rails_helper'

RSpec.describe WeatherHelper, type: :helper do
  let(:response) { 800 }

  describe '#weather_icon_url' do
    context 'when passed an OpenWeather::Response object' do
      it 'returns the correct icon URL for a clear sky' do
        expect(helper.weather_icon_url(response)).to eq('https://openweathermap.org/img/wn/01d@2x.png')
      end
    end

    context 'when passed an integer weather ID' do
      it 'returns the correct icon URL for few clouds (ID: 801)' do
        expect(helper.weather_icon_url(801)).to eq('https://openweathermap.org/img/wn/02d@2x.png')
      end

      it 'raises an error when passed an invalid type' do
        expect { helper.weather_icon_url('invalid') }.to raise_error(ArgumentError, "obj must be a weather id (Integer) or OpenWeather::Response")
      end
    end
  end

  describe '#icon_code' do
    it 'returns the correct icon code for a thunderstorm' do
      expect(helper.icon_code(200)).to eq('11d')
    end

    it 'returns the correct icon code for clear sky' do
      expect(helper.icon_code(800)).to eq('01d')
    end

    it 'returns nil for an unknown weather ID' do
      expect(helper.icon_code(999)).to be_nil
    end
  end
end
