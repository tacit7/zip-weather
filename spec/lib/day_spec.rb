require 'rails_helper'

RSpec.describe OpenWeather::Response::Day do
  let(:day_data) do
    {
      "dt" => 1632949200, # Unix timestamp
      "sunrise" => 1632926800,
      "sunset" => 1632970000,
      "moonrise" => 1632928000,
      "moonset" => 1632972000,
      "moon_phase" => 0.25,
      "temp" => {
        "day" => 298.15,
        "min" => 295.32,
        "max" => 301.15,
        "night" => 293.15,
        "eve" => 296.15,
        "morn" => 297.15
      },
      "feels_like" => {
        "day" => 299.15,
        "night" => 292.15
      },
      "pressure" => 1012,
      "humidity" => 65,
      "dew_point" => 293.15,
      "wind_speed" => 5.14,
      "wind_deg" => 180,
      "wind_gust" => 8.23,
      "weather" => [ { "id" => 800, "description" => "clear sky" } ],
      "clouds" => 0,
      "pop" => 0.0,
      "uvi" => 7.89
    }
  end

  subject { described_class.new(day_data) }

  describe '#initialize' do
    it 'initializes the attributes correctly' do
      expect(subject.dt).to eq(Time.at(1632949200))
      expect(subject.sunrise).to eq(Time.at(1632926800))
      expect(subject.sunset).to eq(Time.at(1632970000))
      expect(subject.moonrise).to eq(Time.at(1632928000))
      expect(subject.moonset).to eq(Time.at(1632972000))
      expect(subject.moon_phase).to eq(0.25)
      expect(subject.temp_day).to eq(298.15)
      expect(subject.temp_min).to eq(295.32)
      expect(subject.temp_max).to eq(301.15)
      expect(subject.temp_night).to eq(293.15)
      expect(subject.temp_eve).to eq(296.15)
      expect(subject.temp_morn).to eq(297.15)
      expect(subject.pressure).to eq(1012)
      expect(subject.humidity).to eq(65)
      expect(subject.dew_point).to eq(293.15)
      expect(subject.wind_speed).to eq(5.14)
      expect(subject.wind_deg).to eq(180)
      expect(subject.wind_gust).to eq(8.23)
      expect(subject.conditions).to eq("clear sky")
      expect(subject.condition_id).to eq(800)
      expect(subject.clouds).to eq(0)
      expect(subject.pop).to eq(0.0)
      expect(subject.uvi).to eq(7.89)
    end
  end

  describe '#icon_url' do
    it 'returns the correct weather icon URL based on condition_id' do
      allow(subject).to receive(:weather_icon_url).with(800).and_return("https://openweathermap.org/img/wn/800@2x.png")
      expect(subject.icon_url).to eq("https://openweathermap.org/img/wn/800@2x.png")
    end
  end

  describe '#date' do
    it 'returns the correct formatted date' do
      expect(subject.date).to eq("2021-09-29")
    end
  end
end
