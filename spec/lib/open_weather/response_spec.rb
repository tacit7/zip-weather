require 'rails_helper'
RSpec.describe OpenWeather::Response do
  let(:response_body) do
    {
      "current" => {
        "temp" => 298.15,
        "weather" => [
          { "id" => 800, "description" => "clear sky" }
        ],
        "humidity" => 50,
        "wind_speed" => 5.14
      },
      "daily" => [
        { "temp" => { "day" => 300.15 }, "weather" => [ { "id" => 801, "description" => "few clouds" } ] },
        { "temp" => { "day" => 295.32 }, "weather" => [ { "id" => 802, "description" => "scattered clouds" } ] }
      ]
    }.to_json
  end

  let(:faraday_response) { instance_double(Faraday::Response, success?: true, body: response_body) }

  subject { described_class.new(faraday_response) }

  describe '#initialize' do
    it 'raises an error if the response is not successful' do
      allow(faraday_response).to receive(:success?).and_return(false)
      expect { described_class.new(faraday_response) }.to raise_error("Unable to retrieve weather data")
    end

    it 'parses the response body' do
      expect(subject.response).to be_a(Hash)
    end
  end

  describe '#temperature' do
    it 'returns the current temperature in integer format' do
      expect(subject.temperature).to eq(298)
    end

    it 'returns nil if temperature is not available' do
      allow(subject.response).to receive(:dig).with("current", "temp").and_return(nil)
      expect(subject.temperature).to be_nil
    end
  end

  describe '#conditions' do
    it 'returns the description of the current weather conditions' do
      expect(subject.conditions).to eq("clear sky")
    end

    it 'returns "Unknown" if weather conditions are not available' do
      allow(subject.response).to receive(:dig).with("current", "weather", 0, "description").and_return(nil)
      expect(subject.conditions).to eq("Unknown")
    end
  end

  describe '#condition_id' do
    it 'returns the current weather condition ID' do
      expect(subject.condition_id).to eq(800)
    end

    it 'returns nil if condition ID is not available' do
      allow(subject.response).to receive(:dig).with("current", "weather", 0, "id").and_return(nil)
      expect(subject.condition_id).to be_nil
    end
  end

  describe '#humidity' do
    it 'returns the current humidity' do
      expect(subject.humidity).to eq(50)
    end

    it 'returns nil if humidity is not available' do
      allow(subject.response).to receive(:dig).with("current", "humidity").and_return(nil)
      expect(subject.humidity).to be_nil
    end
  end

  describe '#wind_speed' do
    it 'returns the current wind speed' do
      expect(subject.wind_speed).to eq(5.14)
    end

    it 'returns nil if wind speed is not available' do
      allow(subject.response).to receive(:dig).with("current", "wind_speed").and_return(nil)
      expect(subject.wind_speed).to be_nil
    end
  end

  describe '#daily' do
    it 'returns an empty array if no daily forecast is available' do
      allow(subject.response).to receive(:[]).with("daily").and_return(nil)
      expect(subject.daily).to eq([])
    end
  end

  describe '#error?' do
    it 'returns true if the response is nil' do
      allow(subject).to receive(:response).and_return(nil)
      expect(subject.error?).to be(true)
    end

    it 'returns true if the response is empty' do
      allow(subject).to receive(:response).and_return({})
      expect(subject.error?).to be(true)
    end

    it 'returns false if the response is present' do
      expect(subject.error?).to be(false)
    end
  end
end
