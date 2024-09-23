class OpenWeatherMapService
  include HTTParty
  base_uri "https://api.openweathermap.org/data/2.5"

  API_KEY = ENV["OPENWEATHERMAP_API_KEY"]

  def fetch_weather_by_zip(zip_code)
    response = self.class.get("/weather", query: { zip: zip_code, appid: API_KEY, units: "imperial" })
    response.parsed_response if response.success?
  end
end
