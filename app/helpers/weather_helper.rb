module WeatherHelper
  def weather_icon_url(obj)
    # Handle either an OpenWeather::Response or an Integer (weather id)
    weather_id =
      if obj.is_a?(OpenWeather::Response)
        # Extract the condition ID from the OpenWeather::Response object
        Integer(obj.condition_id)
      elsif obj.is_a?(Integer)
        # Use the Integer directly if passed as the weather condition id
        obj
      else
        raise ArgumentError, "obj must be a weather id (Integer) or OpenWeather::Response"
      end

    # Get the icon code based on the weather_id
    icon_code = icon_code(weather_id)

    "https://openweathermap.org/img/wn/#{icon_code}@2x.png"
  end

  def icon_code(int)
    case int
    when 200..232 then "11d" # Thunderstorm
    when 300..321 then "09d" # Drizzle
    when 500..504 then "10d" # Rain
    when 511 then "13d"      # Freezing rain
    when 520..531 then "09d" # Shower rain
    when 600..622 then "13d" # Snow
    when 701..781 then "50d" # Atmosphere (Mist, Smoke, Haze, etc.)
    when 800 then "01d"      # Clear sky
    when 801 then "02d"      # Few clouds
    when 802 then "03d"      # Scattered clouds
    when 803..804 then "04d" # Broken/Overcast clouds
    else
      nil # Return nil if no matching icon code
    end
  end
end
