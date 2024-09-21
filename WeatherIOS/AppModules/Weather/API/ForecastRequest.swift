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
/// For temperature in Celsius and maximum wind speed in meter/sec, units=metric
/// dayCount -> forecast for 5 days
/// itemCount -> forecast for 40 weather items
struct ForecastRequest: Encodable {
    var latitude: String
    var longitude: String
    var itemCount = 40
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
        return BaseURL.openweather.url + EndPoints.forecast.rawValue + "?lat=\(latitude)&lon=\(longitude)&cnt=\(itemCount)&appid=\(weatherAPIKey)&units=metric"
        
        /*
         return BaseURL.openweather.url + EndPoints.forecast.rawValue + "/daily?lat=\(latitude)&lon=\(longitude)&cnt=\(dayCount)&appid=\(weatherAPIKey)&units=metric"
         
         for 5 days showing  message = "Invalid API key.
         */
    }
    
    var encoding: Alamofire.ParameterEncoder {
        return URLEncodedFormParameterEncoder.default
    }
}
