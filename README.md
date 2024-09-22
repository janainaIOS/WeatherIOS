# WeatherIOS

WeatherIOS is a simple iOS application that provides current weather details and a 5-day forecast for any city. Users can search for cities, view temperature, high/low temperatures, and weather descriptions, and explore detailed weather information, including humidity, wind speed, and sunrise/sunset times. The app integrates with the OpenWeatherMap API to fetch weather data.

## Features

- **City Weather Listing**: Display weather details for multiple cities, including current temperature, high/low temperatures, and weather descriptions.
- **City Search with Suggestions**: Search for cities with location suggestions for faster navigation..
- **Detailed Weather Forecast**: Navigate to a detailed weather page showing daily and weekly forecasts, sunrise/sunset times, and other weather parameters.
- **User-Friendly Navigation**: Smooth navigation between city list and forecast detail view.
- **Offline**: Weather details of saved locations are available for offline.


## Specification
- **IDE**: Xcode 15.1 
- **Language**: Swift 5 
- **Minimum iOS**: 16

## Architecture

- **MVVM**: Pattern is used to separate the data handling, user interface, and control logic.
- **Network Layer**: APIManager Handles all API requests and responses using Alamofire.
- **Data Layer**: Core Data is used to cache weather data for offline access and performance improvements.

## Libraries

- **Alamofire**: For API interactions 

## Installation

1. Clone the repository:

   https://github.com/janainaIOS/WeatherIOS.git

2. Install dependencies:

   Swift Package Manager: Open the project in Xcode and resolve dependencies through File > Packages > Resolve Package Versions.

3. Open the project:
 
   WeatherIOS.xcodeproj

## Third-Party API Integration
 OpenWeatherMap APIs  (https://openweathermap.org/api) to get current weather and forecast data. To filter weather data, provide the city name, location coordinates, number of days, number of items, or units, along with the API key.

  - https://api.openweathermap.org/data/2.5/weather?q={cityname}&appid={APIkey}
  - https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={APIkey}
## Core Functionalities

1. Weather Listing Page

- Displays the current location with the following details:
   - City Name: Displays the name of the city.
   - Current Temperature: Shows the current temperature.
   - High/Low Temperature: Displays the day’s high and low temperatures.
   - Weather Description: Provides the weather condition (e.g., Sunny, Rainy).
   - Current Time: Shows the city's current time based on its timezone.
- Displays a list of saved cites with weather details.
- Swipe left action to delete save city’s weather information 
2. Search City
- Search Bar: Allows users to search for cities.
- Location Suggestions: Displays suggested city names.
- Selection: On selecting a city, the app navigates to the detailed weather forecast page.
3. Weather Forecast Detail Page
- Display the detailed weather information, including humidity, wind speed, and sunrise/sunset times. 
- Show daily and 5-day forecasts.
- Add button to save the forecast to the database

## Usage
1.	Start the App: Launch the app on your device or simulator.
2.	Search for a City: Use the search bar to find weather information for a specific city.
3.	View Weather Details: Tap on a city to view detailed weather information, including forecasts.

