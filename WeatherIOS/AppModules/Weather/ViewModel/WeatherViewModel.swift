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
    /// pass latitude, longitude
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
    
    func getforecastDetails(lat: String, lng: String, completion:@escaping (Forecast?) -> Void) {
        forecastService.load(request: ForecastRequest(latitude: lat, longitude: lng)) { [weak self] response in
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
    
    
}
