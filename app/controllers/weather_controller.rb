class WeatherController < ApplicationController
  def show
    # Create an Address object from the input parameters
    address = Address.new(city: params[:city], state: params[:state], country: "US", zip_code: params[:zip_code])

    # Instantiate the Geocoder with the Address object
    geocoder = OpenWeather::Geocoder.new(address)
    @location = geocoder.fetch

    # Handle geocoding errors using methods
    return redirect_with_error(geocoder.error_messages)     if geocoder_error?(geocoder)
    return redirect_with_error("Unable to geocode address") if @location.nil?

    # Fetch weather data using the coordinates from the Location object
    @response = OpenWeather::Weather.fetch(@location)

    # Cache the weather data if not cached
    cache_weather_data(@location, @response)
  end

  private

  ##
  # Determines if a geocoder encountered an error.
  #
  # @param geocoder [OpenWeather::Geocoder] The geocoder object to check for errors.
  # @return [Boolean] True if the geocoder encountered an error, otherwise false.
  def geocoder_error?(geocoder)
    geocoder.error?
  end

  ##
  # Caches the weather data if it is not already cached.
  #
  # @param location [Location] The geocoded location with lat/lon and optional zip.
  # @param weather_data [Hash] The weather data fetched from the API.
  # @return [void]
  def cache_weather_data(location, weather_data)
    address_key = cache_key(location)

    unless Rails.cache.exist?(address_key)
      @cached = false
      Rails.cache.write(address_key, weather_data, expires_in: 30.minutes)
    else
      @cached = true
    end
  end

  ##
  # Constructs a cache key based on the latitude and longitude of a location.
  #
  # @param location [Location] The geocoded location.
  # @return [String] A unique cache key for the location.
  def cache_key(location)
    "#{location.zip_code}"
  end

  ##
  # Redirects with an error message.
  #
  # @param message [String] The error message to display.
  # @return [void]
  def redirect_with_error(message)
    flash[:alert] = message
    redirect_to new_address_path and return
  end
end
