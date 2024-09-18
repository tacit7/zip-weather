module OpenWeather
  class Response
    class Day
      include WeatherHelper

      # @!attribute [r] clouds
      #   @return [Integer] Cloud coverage as a percentage
      # @!attribute [r] conditions
      #   @return [String] Weather description (e.g., 'clear sky')
      # @!attribute [r] condition_id
      #   @return [Integer] Unique identifier for the weather condition
      # @!attribute [r] dew_point
      #   @return [Float] Dew point in degrees Fahrenheit or Celsius
      # @!attribute [r] dt
      #   @return [Time] Unix timestamp representing the date and time
      # @!attribute [r] humidity
      #   @return [Integer] Humidity percentage
      # @!attribute [r] moon_phase
      #   @return [Float] Moon phase value (0 to 1)
      # @!attribute [r] moonrise
      #   @return [Time] Unix timestamp for moonrise
      # @!attribute [r] moonset
      #   @return [Time] Unix timestamp for moonset
      # @!attribute [r] pop
      #   @return [Float] Probability of precipitation (0 to 1)
      # @!attribute [r] pressure
      #   @return [Integer] Atmospheric pressure in hPa
      # @!attribute [r] summary
      #   @return [String] Short summary of the weather
      # @!attribute [r] sunrise
      #   @return [Time] Unix timestamp for sunrise
      # @!attribute [r] sunset
      #   @return [Time] Unix timestamp for sunset
      # @!attribute [r] temp_day
      #   @return [Float] Daytime temperature
      # @!attribute [r] temp_eve
      #   @return [Float] Evening temperature
      # @!attribute [r] temp_max
      #   @return [Float] Maximum temperature for the day
      # @!attribute [r] temp_min
      #   @return [Float] Minimum temperature for the day
      # @!attribute [r] temp_morn
      #   @return [Float] Morning temperature
      # @!attribute [r] temp_night
      #   @return [Float] Nighttime temperature
      # @!attribute [r] uvi
      #   @return [Float] UV index
      # @!attribute [r] wind_deg
      #   @return [Integer] Wind direction in degrees
      # @!attribute [r] wind_gust
      #   @return [Float] Wind gust speed
      # @!attribute [r] wind_speed
      #   @return [Float] Wind speed

      attr_reader :clouds,        :conditions,    :condition_id,   :dew_point,     :dt,
                  :humidity,      :moon_phase,    :moonrise,       :moonset,       :pop,
                  :pressure,      :summary,       :sunrise,        :sunset,        :temp_day,
                  :temp_eve,      :temp_max,      :temp_min,       :temp_morn,     :temp_night,
                  :uvi,           :wind_deg,      :wind_gust,      :wind_speed

      # Initializes a Day object with weather data for a specific day
      #
      # @param [Hash] day The data hash containing all relevant weather information for the day
      # @option day [Integer] 'dt' Unix timestamp for the date
      # @option day [Integer] 'sunrise' Unix timestamp for sunrise
      # @option day [Integer] 'sunset' Unix timestamp for sunset
      # @option day [Integer] 'moonrise' Unix timestamp for moonrise
      # @option day [Integer] 'moonset' Unix timestamp for moonset
      # @option day [Float] 'moon_phase' Moon phase (0 to 1)
      # @option day [Hash] 'temp' Hash containing temperature data for various times of day
      # @option day [Hash] 'feels_like' Hash containing "feels like" temperatures for day and night
      # @option day [Integer] 'pressure' Atmospheric pressure in hPa
      # @option day [Integer] 'humidity' Humidity percentage
      # @option day [Float] 'dew_point' Dew point temperature
      # @option day [Float] 'wind_speed' Wind speed
      # @option day [Integer] 'wind_deg' Wind direction in degrees
      # @option day [Float] 'wind_gust' Wind gust speed
      # @option day [Array] 'weather' Array containing weather conditions (e.g., description, id)
      # @option day [Integer] 'clouds' Cloud coverage percentage
      # @option day [Float] 'pop' Probability of precipitation (0 to 1)
      # @option day [Float] 'uvi' UV index
      def initialize(day)
        @dt         = Time.at(day["dt"])
        @sunrise    = Time.at(day["sunrise"])
        @sunset     = Time.at(day["sunset"])
        @moonrise   = Time.at(day["moonrise"])
        @moonset    = Time.at(day["moonset"])
        @moon_phase = day["moon_phase"]
        @summary    = day["summary"]

        # Extract individual temperature data
        @temp_day   = day.dig("temp", "day")
        @temp_min   = day.dig("temp", "min")
        @temp_max   = day.dig("temp", "max")
        @temp_night = day.dig("temp", "night")
        @temp_eve   = day.dig("temp", "eve")
        @temp_morn  = day.dig("temp", "morn")

        # Extract feels like data for day and night
        @feels_like_day   = day.dig("feels_like", "day")
        @feels_like_night = day.dig("feels_like", "night")

        # Other weather-related attributes
        @pressure     = day["pressure"]
        @humidity     = day["humidity"]
        @dew_point    = day["dew_point"]
        @wind_speed   = day["wind_speed"]
        @wind_deg     = day["wind_deg"]
        @wind_gust    = day["wind_gust"]
        @conditions   = day.dig("weather", 0, "description") # Assuming the first weather element is the most relevant
        @condition_id = day.dig("weather", 0, "id")
        @clouds       = day["clouds"]
        @pop          = day["pop"]
        @uvi          = day["uvi"]
      end

      # Returns the URL for the weather icon based on the weather condition ID
      #
      # @return [String] URL for the weather icon image
      def icon_url
        @icon_url ||= weather_icon_url(condition_id)
      end

      # Returns the date in a readable format (YYYY-MM-DD)
      #
      # @return [String] The formatted date
      def date
        @dt.strftime("%Y-%m-%d")
      end
    end
  end
end
