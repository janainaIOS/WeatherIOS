//
//  ForecastRequest.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation
import Alamofire

/// Get forecast details using location coordinates
/// pass latitude, longitude, APIKey
/// units -> metric, For temperature in Celsius and maximum wind speed in meter/sec
/// dayCount -> forecast for 5 days
/// itemCount -> forecast for  weather items
/// id -> Pass id to get details of that city
/// name -> Pass city name to get details of that city

struct ForecastRequest: Encodable {
    var latitude: String
    var longitude: String
    var id: Int = 0
    var itemCount = 1
    var cityName: String
    //var dayCount = 5
}

extension ForecastRequest: NetworkRequest {
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return .default
    }
    
    var url: String {
        if id != 0 {
            /// fetch forcast with city id 
            return BaseURL.openweather.url + EndPoints.forecast.rawValue + "?id=\(id)&appid=\(weatherAPIKey)&units=metric"
        } else if cityName != "" {
            /// fetch forcast with city name
            return BaseURL.openweather.url + EndPoints.forecast.rawValue + "?q=\(cityName)&appid=\(weatherAPIKey)&units=metric"
        } else {
            /// fetch forcast with coordinates
            return BaseURL.openweather.url + EndPoints.forecast.rawValue + "?lat=\(latitude)&lon=\(longitude)&cnt=\(itemCount)&appid=\(weatherAPIKey)&units=metric"
        }
        
        /*
         return BaseURL.openweather.url + EndPoints.forecast.rawValue + "/daily?lat=\(latitude)&lon=\(longitude)&cnt=\(dayCount)&appid=\(weatherAPIKey)&units=imperial"
         
         for 5 days showing  message = "Invalid API key.
         */
    }
    
    var encoding: Alamofire.ParameterEncoder {
        return URLEncodedFormParameterEncoder.default
    }
}
