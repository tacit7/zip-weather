# ZipWeather

## ABOUT
This is a rails app that provides weather forecast information based on an address. The app interacts with the OpenWeatherMap API to fetch the current weather, high/low temperatures, and a 5-day forecast. It caches the weather data for 30 minutes. The app also provides a simple user interface powered by Bootstrap.
## Setup

To set up the project locally, follow the steps below.

### Prerequisites
- ruby 3.3.4
- bundler
-  
### How to Run the App

To run this application locally, follow the steps below:

#### 1. Clone the Repository

First, clone the repository to your local machine:

```bash
git clone git@github.com:tacit7/zip-weather.git
cd zip-weather
```

#### 2. Install Dependencies

Once inside the project directory, run the following command to install the necessary gems:

```bash
bundle install
```

#### 3. Precompile Assets

Next, you'll need to precompile the assets to make sure all the stylesheets, JavaScript, and other assets are ready for the application:

```bash
bundle exec rails assets:precompile
```

#### 4. Setup the Database

If your application uses a database, run the following commands to set up the database:

```bash
rails db:create
rails db:migrate
```

#### 5. Start the Rails Server

Once everything is set up, you can start the Rails server:

```bash
rails server
```

The application will be available at `http://localhost:3000` in your browser.

---
## Yard Documentation

You can vew yard documentation using the `yard server` command in the root directory of the application.

## Decomposition

The project is decomposed the following components:

### OpenWeather::Geocoder

- This class is responsible for translating an address into geographic coordinates by using the OpenWeatherMap Geocoding API.
- It includes methods like `fetch` to make the API request, and `geo_coordinates` to extract the latitude and longitude from the API response.

### OpenWeather::Weather

- This class uses the OpenWeatherMap API to fetch the current weather and extended forecasts based on the geographic coordinates provided by `Geocoder`.
- It fetches temperature, weather conditions, humidity, wind speed, and more, all encapsulated within the `Response` object.

### OpenWeather::Response

- This class is responsible for parsing and extracting the relevant weather data from the API response. It provides methods to get details like `temperature`, `conditions`, `condition_id`, `humidity`, `wind_speed`, and a 5-day `daily` forecast.
- It ensures that the response is correctly parsed and handles errors using  `error?` and `error_messages` methods.

### OpenWeather::Response::Day

- The `Day` class represents a single day's forecast. 
- This class abstracts the weather data for a specific day from the API.

### FetchWeatherJob (unable to finish)

- This background job processes the weather data asynchronously, fetching weather information for a specific address and broadcasting the result via ActionCable.
- It handles caching the weather data using Rails’ caching mechanism to avoid redundant API calls.

## Design Patterns

The following design patterns were utilized in the app:

### 1. **Service Object Pattern**

The `OpenWeather::Geocoder` and `OpenWeather::Weather` classes act as service objects that encapsulate the logic for interacting with external APIs (OpenWeatherMap). This ensures that external service interactions are kept separate from the business logic of the application.

#### Why Service Objects are Placed in the `lib` Directory

Service objects are placed in the `lib` directory because there may be an opportunity for other codebases or projects to reuse this code.


### 2. **Decorator Pattern**

The `Response` class serves as a decorator for the raw API response. 


## Scalability Considerations

Several strategies were employed to ensure the app can scale efficiently as the number of users or weather requests grows:

### 1. **Caching**

To reduce the number of API calls and improve performance, weather data is cached for 30 minutes based on the zip code.
### 2. **Background Job Processing** (not finished)

Fetching weather data and geocoding is handled asynchronously by `FetchWeatherJob`. By processing this in the background, the app remains responsive even if the API request takes longer to complete. This makes the app more scalable as it can handle multiple weather requests without blocking the user interface.

### 3. **Modular Design**

The decomposition of the application into multiple classes ensures that individual components can be extended or modified independently. This makes it easier to introduce new features or adjust the behavior of specific parts of the app without introducing complexity into other areas.


### 5. **Database Efficiency**

SQLite is used for development, but in production environments, switching to PostgreSQL or MySQL would ensure better scalability and performance under high load, especially with larger datasets and more users. Indexing critical fields like zip code in the `Address` model would help optimize database queries for weather data.

## Security Concerns

### **Environment Variables for Sensitive Data**

The OpenWeatherMap API key is stored in environment variables using the `dotenv-rails` gem, ensuring that sensitive information is not exposed in the codebase. The API key should never be hardcoded, and in production environments, it should be stored securely, such as in the server environment or a secrets manager (like AWS Secrets Manager or Heroku Config Vars).
