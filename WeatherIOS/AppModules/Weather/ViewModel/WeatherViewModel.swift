//
//  WeatherViewModel.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation

final class WeatherViewModel {
    
    let weatherService: WeatherService
    let weatherFromNameService: WeatherFromNameService
    let forecastService: ForecastService
    
    init(weatherService: WeatherService = RemoteWeatherService(), weatherFromNameService: WeatherFromNameService = RemoteWeatherFromNameService(), forecastService: ForecastService = RemoteForecastService()) {
        self.weatherService             = weatherService
        self.weatherFromNameService     = weatherFromNameService
        self.forecastService            = forecastService
    }
    
    /// Get weather details using location coordinates
    /// pass coordinates latitude, longitude
    func getWeatherDetail(lat: String, lng: String, completion:@escaping (Weather?) -> Void) {
        weatherService.load(request: WeatherRequest(latitude: lat, longitude: lng)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let model):
                completion(model)
            case .failure(let error):
                Toast.show(error.description)
                completion(nil)
            }
        }
    }
    
    /// Get weather details using location name
    /// pass name of location
    func getWeatherDetail(location: String, completion:@escaping (Weather?) -> Void) {
        weatherFromNameService.load(request: WeatherFromNameRequest(location: location)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let model):
                completion(model)
            case .failure(let error):
                Toast.show(error.description)
                completion(nil)
            }
        }
    }
    
    /// Get forecast details using location name
    /// pass coordinates latitude, longitude
    /// itemCount is the count of weather items
    /// id -> Pass id to get details of that city
    func getforecastDetails(lat: String = "", lng: String = "", itemCount: Int, cityId: Int = 0, cityName: String = "", completion:@escaping (Forecast?) -> Void) {
        forecastService.load(request: ForecastRequest(latitude: lat, longitude: lng, id: cityId, itemCount: itemCount, cityName: cityName)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let model):
                completion(model)
            case .failure(let error):
                Toast.show(error.description)
                completion(nil)
            }
        }
    }
    
    /// Find the closest weather by comparing each weather date to the current date
    func getClosestWeather(from forecast: Forecast) -> Weather? {
        if forecast.list.isEmpty  {
            print("No weather data available.")
            return nil
        } else {
            
            let currentDate = Date()
            
            // Find the closest weather by comparing each weather date to the current date
            let closestWeather = forecast.list.min(by: { weather1, weather2 in
                guard let date1 = weather1.dateTime.formatToDate(inputFormat: dateFormat.yyyyMMddHHmmss), let date2 = weather2.dateTime.formatToDate(inputFormat: dateFormat.yyyyMMddHHmmss) else {
                    return false
                }
                // Compare which date is closer to the current date
                return abs(date1.timeIntervalSince(currentDate)) < abs(date2.timeIntervalSince(currentDate))
            })
            
            print("Closest Weather: \(closestWeather)")
            return closestWeather
        }
    }
    
    
    /// To filter today's forecast from a list of Weather objects
    func getTodayForecasts(from forecasts: [Weather]) -> [Weather] {
        // Get the current date and remove time components
        let today = Calendar.current.startOfDay(for: Date())
        
        // Filter forecasts to include only those with dates matching today
        let todayForecasts = forecasts.filter { forecast in
            // Convert dateTime string to Date object
            
            if let forecastDate = forecast.dateTime.formatToDate(inputFormat: .yyyyMMddHHmmss) {
                // Check if the forecast date is the same as today
                return Calendar.current.isDate(forecastDate, inSameDayAs: today)
            }
            return false
        }
        
        return todayForecasts
    }
    
    // To get the first weather forecast for each unique date
    func getFirstWeatherForEachDate(from forecasts: [Weather]) -> [Weather] {
        
        var firstWeatherByDate: [String: Weather] = [:]
        
        for forecast in forecasts {
            // Parse the date part from the dateTime string
            if let forecastDate = forecast.dateTime.formatToDate(inputFormat: .yyyyMMddHHmmss) {
                
                // Extract the date component as a string without the time part
                let dateString = forecastDate.formatDate(outputFormat: .yyyyMMdd)
                
                // Check if this date is already added to the dictionary, if not add to the list
                if firstWeatherByDate[dateString] == nil {
                    firstWeatherByDate[dateString] = forecast
                }
            }
        }
        
        // Sort the results
        let sortedWeathers = firstWeatherByDate.values.sorted { (weather1, weather2) -> Bool in
            let date1 = weather1.dateTime.formatToDate(inputFormat: .yyyyMMddHHmmss) ?? Date.distantFuture
            let date2 = weather2.dateTime.formatToDate(inputFormat: .yyyyMMddHHmmss) ?? Date.distantFuture
            return date1 < date2
        }
        
        return Array(sortedWeathers)
    }
    
    
    /// Covert DBForecast -> Forecast
    func DBForecastToForecast(dbforecast: DBForecast) -> Forecast? {
        var forecast = Forecast()
        
        forecast.isHome = dbforecast.isHome
        forecast.city.timezone = Int(dbforecast.timezone)
        if let forecastSet = dbforecast.forecasts as? Set<DBWeather> {
            for dbWeather in forecastSet {
                if let weather = DBWeatherToWeather(dbWeather: dbWeather) {
                    forecast.list.append(weather)
                }
            }
        }
        
        if forecast.list.count > 0 {
            forecast.city.name = forecast.list.first?.cityName ?? ""
            forecast.city.coord = forecast.list.first?.cordinate
            forecast.city.id = forecast.list.first?.id ?? 0
            forecast.city.sunset = forecast.list.first?.sys?.sunset ?? 0
            forecast.city.sunrise = forecast.list.first?.sys?.sunrise ?? 0
        }
        return forecast
        
    }
    
    /// Covert DBWeather -> Weather
    func DBWeatherToWeather(dbWeather: DBWeather) -> Weather? {
        var weather = Weather()
        weather.id = Int(dbWeather.id)
        weather.cityName = dbWeather.cityName ?? ""
        weather.dateTime = dbWeather.date ?? ""
        weather.descriptn = [
            Descriptn(description: dbWeather.descriptn, main: dbWeather.descriptnMain)
        ].compactMap { $0 }
        weather.cordinate = LocCordinate(longitude: dbWeather.longitude, latitude: dbWeather.latitude)
        
        weather.temparature = Temparature(
            temp: dbWeather.temp,
            minTemp: dbWeather.minTemp,
            maxTemp: dbWeather.maxTemp,
            humidity: dbWeather.humidity,
            pressure: dbWeather.pressure
        )
        
        weather.wind = Wind(speed: dbWeather.windSpeed)
        weather.sys = Sys(sunrise: dbWeather.sunrise, sunset: dbWeather.sunset)
        weather.isHome = dbWeather.isHome
        return weather
    }
}
