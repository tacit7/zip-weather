module OpenWeather
  ##
  # `OpenWeather::Geocoder` uses the OpenWeatherMap API to geocode addresses
  # into geographic coordinates.
  #
  # The class is initialized with an `Address` object and provides functionality
  # to fetch latitude and longitude based on the address, country, and zip code.
  # It returns a `Location` object that contains the geographic data.
  #
  # Example usage:
  #   address = Address.new(street: "123 Main St", city: "Austin", state: "TX", country: "US", zip_code: "73301")
  #   geocoder = OpenWeather::Geocoder.new(address)
  #   location = geocoder.fetch
  #
  # The `fetch` method will return a `Location` object with latitude, longitude, and zip code.
  #
  class Geocoder
    include OpenWeather::Client

    # Make the address and data accessible with readers
    attr_reader :address, :data

    ##
    # Initializes the Geocoder with an Address object.
    #
    # @param address [Address] An Address object containing street, city, state, country, and zip_code.
    def initialize(address)
      @address = address
    end

    def self.fetch(address)
      new(address).fetch
    end
    ##
    # Fetches the geocoding data from the API and returns a Location object.
    #
    # @return [Location, nil] A Location object with `:lat`, `:lon`, and optional `:zip`, or nil if not found.
    def fetch
      @response = connect.get(GEO_API_ENDPOINT, query_params)
      @data = JSON.parse(@response.body, symbolize_names: true)
      return nil if error?

      location
    end

    ##
    # Builds the query parameters for the API request using the address reader.
    #
    # @return [Hash] The query parameters for the API request.
    def query_params
      {
        zip: "#{address.zip_code},#{address.country}",
        appid: OpenWeather::Client::KEY
      }
    end

    ##
    # Returns the full query URL by extracting the URL from the response environment.
    #
    # @return [String] The full query URL.
    def query
      @response.env.url.to_s  # Extracts the full URL from the response object
    end

    ##
    # Creates and returns a Location object from the geocoded coordinates.
    #
    # @return [Location, nil] A Location object or nil if no valid coordinates were found.
    def location
      return nil if @data.empty?

      lat = @data[:lat]
      lon = @data[:lon]
      Location.new(lat: lat, lon: lon, zip_code: address.zip_code)
    end

    ##
    # Checks if there was an error in the API response.
    #
    # @return [Boolean] True if an error occurred, false otherwise.
    def error?
      @data.key?(:cod) && @data[:cod] != 200
    end

    ##
    # Retrieves any error messages from the API response.
    #
    # @return [String, nil] The error message if there is an error, or nil if there are no errors.
    def error_messages
      return @data[:message] if error?
      nil
    end
  end
end
