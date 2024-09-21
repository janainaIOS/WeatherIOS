//
//  BaseURL.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation

public enum BaseURL: String {
    case openweather
    
    private var environment: Environment {
        Environment.test
    }
    
    var url: String {
        switch self {
        case .openweather:
            switch environment {
            case .test, .staging, .production:
                return "https://api.openweathermap.org/data/2.5/"
            }
        }
    }
}
