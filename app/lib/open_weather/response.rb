require_relative "./day"

module OpenWeather
  # Response class to parse and extract weather data from the OpenWeatherMap API response
  #
  # @example Fetching and parsing weather data
  #   response = OpenWeatherMap::Client.zip('90210')
  #   weather_data = response.parse
  #   puts weather_data[:temperature]
  #
  class Response
    # @!attribute [r] response
    #   @return [Hash] Parsed body of the OpenWeatherMap API response
    attr_reader :response

    # Initializes the Response object and verifies the success of the response.
    #
    # @param response [Faraday::Response] The HTTP response from the API call
    # @raise [RuntimeError] If the response is not successful
    def initialize(response)
      raise "Unable to retrieve weather data" unless response.success?

      @response = JSON response.body
    end

    # Extracts the current temperature from the response.
    #
    # @return [Integer, nil] The current temperature, or `nil` if data is missing or invalid
    def temperature
      Integer(response.dig("current", "temp"))
    rescue StandardError
      nil
    end

    # Extracts the description of the current weather conditions.
    #
    # @return [String] A string describing the current weather conditions, or 'Unknown' if not available
    def conditions
      response.dig("current", "weather", 0, "description") || "Unknown"
    end

    # Extracts the current weather condition ID.
    #
    # @return [Integer, nil] The condition ID, or `nil` if data is missing or invalid
    def condition_id
      Integer(response.dig("current", "weather", 0, "id"))
    rescue StandardError
      nil
    end

    # Extracts the current humidity.
    #
    # @return [Integer, nil] The current humidity as a percentage, or `nil` if data is missing
    def humidity
      response.dig("current", "humidity") || nil
    end

    # Extracts the current wind speed.
    #
    # @return [Float, nil] The current wind speed in the requested units, or `nil` if data is missing
    def wind_speed
      response.dig("current", "wind_speed") || nil
    end

    # Parses the relevant weather data into a hash.
    #
    # @return [Hash] A hash containing key weather values: `:temperature`, `:conditions`, `:humidity`, and `:wind_speed`
    def parse
      {
        temperature: temp,
        conditions:,
        humidity:,
        wind_speed:
      }
    end

    # Extracts the extended daily forecast data.
    #
    # @return [Array<OpenWeatherMap::Response::Day>] An array of `Day` objects, one for each day of the forecast
    def daily
      return [] unless response["daily"]

      @extended_forecast ||= response["daily"].map do |d|
        OpenWeather::Response::Day.new(d)
      end
    end

    # Checks if there was an error in the response.
    #
    # @return [Boolean] true if the response is nil or empty, false otherwise
    def error?
      !response || response.empty?
    end
  end
end
