##
# The Address class holds the information about a user's address.
# It is initialized with city, state, and country.
# There is no need for acticvation of the address in this project.
class Address
  attr_accessor :city, :state, :country, :zip_code

  ##
  # Initializes the Address object with city, state, and country.
  #
  # @param city [String] The name of the city.
  # @param state [String] The state code (e.g., "TX").
  # @param country [String] The country code (e.g., "US").
  def initialize(city:, state:, country:, zip_code:)
    @city    = city
    @state   = state
    @country = country
    @zip_code = zip_code
    @country_code = country.upcase
  end


  ##
  # Returns a formatted address string for querying the geolocation API.
  #
  # @return [String] A string representing the formatted address.
  def query_format
    "#{zip_code},US"
  end
end
