# ZipWeather

## ABOUT

ZipWeather is a Ruby on Rails application that provides weather forecast information based on a user-provided address (street, city, state, and zip code). The app interacts with the OpenWeatherMap API to fetch the current weather, high/low temperatures, and a 5-day forecast. It caches the weather data for 30 minutes to improve performance and reduce API calls. The app also provides a simple user interface powered by Bootstrap and supports background job processing to fetch weather data asynchronously.

## Decomposition

The project is decomposed into the following key components to ensure modularity and separation of concerns:

### OpenWeather::Geocoder

- This class is responsible for translating an address (including street, city, state, and zip code) into geographic coordinates (latitude and longitude) by calling the OpenWeatherMap Geocoding API.
- It includes methods like `fetch` to make the API request, and `geo_coordinates` to extract the latitude and longitude from the API response.

### OpenWeather::Weather

- This class interacts with the OpenWeatherMap API to fetch the current weather and extended forecasts based on the geographic coordinates provided by `Geocoder`.
- It fetches temperature, weather conditions, humidity, wind speed, and more, all encapsulated within the `Response` object.

### OpenWeather::Response

- This class is responsible for parsing and extracting the relevant weather data from the API response. It provides methods to get details like `temperature`, `conditions`, `condition_id`, `humidity`, `wind_speed`, and a 5-day `daily` forecast.
- It ensures that the response is correctly parsed and handles errors gracefully by providing the `error?` and `error_messages` methods.

### OpenWeather::Response::Day

- The `Day` class represents a single day's weather forecast. It holds attributes like `temp_day`, `temp_min`, `temp_max`, `conditions`, and `icon_url` for a given day.
- This class abstracts the weather data for a specific day from the API and provides easy-to-access methods for all weather-related attributes.

### FetchWeatherJob

- This background job processes the weather data asynchronously, fetching weather information for a specific address and broadcasting the result via ActionCable.
- It handles caching the weather data using Rails’ caching mechanism to avoid redundant API calls.

## Design Patterns

The following design patterns were utilized in the app:

### 1. **Service Object Pattern**

The `OpenWeather::Geocoder` and `OpenWeather::Weather` classes act as service objects that encapsulate the logic for interacting with external APIs (OpenWeatherMap). This ensures that external service interactions are kept separate from the business logic of the application.

### 2. **Decorator Pattern**

The `Response` class serves as a decorator for the raw API response, providing more meaningful methods to interact with the response data, such as `temperature`, `conditions`, `humidity`, and more. This pattern enhances the usability of the API response without modifying the underlying data structure.

### 3. **Observer Pattern (ActionCable)**

ActionCable is used to broadcast weather updates to the client in real time. The `FetchWeatherJob` sends the weather data back to the client via ActionCable, which listens for updates and modifies the view asynchronously. This pattern helps decouple the data-fetching logic from the UI, allowing for a more responsive user experience.

## Scalability Considerations

Several strategies were employed to ensure the app can scale efficiently as the number of users or weather requests grows:

### 1. **Caching**

To reduce the number of API calls and improve performance, weather data is cached for 30 minutes based on the zip code. This reduces the load on the external OpenWeatherMap API and ensures faster response times for repeat requests within the cache duration.

### 2. **Background Job Processing**

Fetching weather data and geocoding is handled asynchronously by `FetchWeatherJob`. By processing this in the background, the app remains responsive even if the API request takes longer to complete. This makes the app more scalable as it can handle multiple weather requests without blocking the user interface.

### 3. **Modular Design**

The decomposition of the application into multiple classes (Geocoder, Weather, Response, and Day) ensures that individual components can be extended or modified independently. This makes it easier to introduce new features or adjust the behavior of specific parts of the app without introducing complexity into other areas.

### 4. **ActionCable for Real-time Updates**

Using ActionCable to broadcast weather data ensures that the app can scale to provide real-time updates to multiple users simultaneously. As the number of users grows, the app can push updates to many clients concurrently, allowing for efficient and scalable real-time communication.

### 5. **Database Efficiency**

SQLite is used for development, but in production environments, switching to PostgreSQL or MySQL would ensure better scalability and performance under high load, especially with larger datasets and more users. Indexing critical fields like zip code in the `Address` model would help optimize database queries for weather data.

## Security Concerns

### **Environment Variables for Sensitive Data**

The OpenWeatherMap API key is stored in environment variables using the `dotenv-rails` gem, ensuring that sensitive information is not exposed in the codebase. The API key should never be hardcoded, and in production environments, it should be stored securely, such as in the server environment or a secrets manager (like AWS Secrets Manager or Heroku Config Vars).
