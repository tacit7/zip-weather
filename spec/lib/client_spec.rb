RSpec.describe OpenWeather::Client do
  include OpenWeather::Client

  describe '#connect' do
    it 'returns a Faraday connection' do
      connection = connect
      expect(connection).to be_a(Faraday::Connection)
    end

    it 'sets the base URL correctly' do
      connection = connect
      expect(connection.url_prefix.to_s).to eq("https://api.openweathermap.org/")
    end
  end

  describe 'API key setup' do
    it 'sets the API key from the environment' do
      expect(OpenWeather::Client::KEY).to eq(ENV['OPEN_WEATHER_API_KEY'])
    end
  end
end
