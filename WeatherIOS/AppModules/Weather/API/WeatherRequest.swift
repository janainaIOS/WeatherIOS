//
//  WeatherRequest.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation
import Alamofire

/// Get weather details using location coordinates
/// pass latitude, longitude, APIKey
/// units -> metric, For temperature in Celsius and maximum wind speed in meter/sec
struct WeatherRequest: Encodable {
    var latitude: String
    var longitude: String
}

extension WeatherRequest: NetworkRequest {
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return .default
    }
    
    var url: String {
        return BaseURL.openweather.url + EndPoints.weather.rawValue + "?lat=\(latitude)&lon=\(longitude)&appid=\(weatherAPIKey)&units=metric"
    }
    
    var encoding: Alamofire.ParameterEncoder {
        return URLEncodedFormParameterEncoder.default
    }
}
