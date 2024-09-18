##
# The Location class holds the result from the geocoding API, including latitude, longitude, and zip code.
class Location
  attr_accessor :lat, :lon, :zip_code

  ##
  # Initializes the Location object with latitude, longitude, and optional zip code.
  #
  # @param lat [Float] The latitude of the location.
  # @param lon [Float] The longitude of the location.
  # @param zip_code [String, nil] Optional. The zip code of the location.
  def initialize(lat:, lon:, zip_code: nil)
    @lat = lat
    @lon = lon
    @zip_code = zip_code
  end

  def ==(other)
    lat == other.lat && lon == other.lon
  end
  ##
  # Builds a Location object from the geocoding API response.
  #
  # @param data [Hash] The geocoding response data containing latitude and longitude.
  # @return [Location] A new Location object with lat, lon, and optional zip code.
  def self.from_geocoder_data(data)
    lat = data[:lat]
    lon = data[:lon]
    zip = data[:zip_code]  # Optional, if zip code is available in the response
    new(lat: lat, lon: lon, zip_code: zip)
  end
end
