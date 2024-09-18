module OpenWeather
  ##
  # `OpenWeather::Weather` fetches weather data from the OpenWeatherMap API
  # based on geographic coordinates (latitude and longitude).
  #
  # The class includes the `Client` module and returns weather data using
  # the custom `OpenWeatherMap::Response` and `Day` classes.
  #
  class Weather
    include OpenWeather::Client

    ##
    # Initializes the Weather class with either a Location object or latitude and longitude.
    #
    # @param params [Location, Float, Float] Either a Location object, or latitude and longitude.
    # @raise [ArgumentError] Raises an error if invalid arguments are provided.
    def initialize(*params)
      if params[0].is_a?(Location)
        @lat = params[0].lat
        @lon = params[0].lon
      elsif params[0].is_a?(Float) && params[1].is_a?(Float)
        @lat = params[0]
        @lon = params[1]
      else
        raise ArgumentError, "Expected a Location object or latitude and longitude as floats"
      end
    end

    ##
    # Instance method to fetch weather data for the given coordinates and return a `Response` object.
    #
    # @return [OpenWeather::Response] Parsed weather data as an `OpenWeather::Response` object.
    def fetch
      response = connect.get(WEATHER_API_ENDPOINT, {
        lat: @lat,
        lon: @lon,
        appid: OpenWeather::Client::KEY,
        units: "imperial"  # For Fahrenheit, or 'metric' for Celsius
      })

      OpenWeather::Response.new(response)
    end

    ##
    # Class method to fetch weather data by instantiating the Weather class.
    #
    # @param params [Location, Float, Float] Either a Location object, or latitude and longitude.
    # @return [OpenWeatherMap::Response] Parsed weather data as an `OpenWeatherMap::Response` object.
    def self.fetch(*params)
      new(*params).fetch
    end
  end
end
