//
//  WeatherFromNameRequest.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation
import Alamofire

/// Get weather details using location name
/// pass name of location, APIKey
/// units -> metric, For temperature in Celsius and maximum wind speed in meter/sec
struct WeatherFromNameRequest: Encodable {
    var location: String
}

extension WeatherFromNameRequest: NetworkRequest {
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return .default
    }
    
    var url: String {
        return BaseURL.openweather.url + EndPoints.weather.rawValue + "?q=\(location)&appid=\(weatherAPIKey)&units=metric"
    }
    
    var encoding: Alamofire.ParameterEncoder {
        return URLEncodedFormParameterEncoder.default
    }
}
