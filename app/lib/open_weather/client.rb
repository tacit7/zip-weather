##
# The `OpenWeather` module serves as a namespace for classes and modules
# that interact with the OpenWeatherMap API.
module OpenWeather
  ##
  # The `Client` module provides a Faraday connection to the OpenWeatherMap API,
  # including constants for API endpoints.
  module Client
    # Endpoint for fetching weather data
    WEATHER_API_ENDPOINT = "data/3.0/onecall"
    # Endpoint for geocoding addresses
    GEO_API_ENDPOINT = "/geo/1.0/zip"

    # Base URL for the OpenWeatherMap API
    BASE_URL = "https://api.openweathermap.org"

    # API key for the OpenWeatherMap API
    KEY = ENV["OPEN_WEATHER_API_KEY"]

    ##
    # Returns a Faraday connection object configured with the base URL.
    #
    # @return [Faraday::Connection] A Faraday connection instance.
    def connect
      Faraday.new(url: BASE_URL) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
