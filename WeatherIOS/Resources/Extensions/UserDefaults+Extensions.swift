//
//  UserDefaults+Extensions.swift
//  WeatherIOS
//
//  Created by Janaina A on 21/09/2024.
//

import Foundation

extension UserDefaults {
    
    var currentLocation: Forecast? {
        get {
            if let decodedData = value(forKey: .currentLocation) as? Data {
                let decodedValue = try? JSONDecoder().decode(Forecast.self, from: decodedData)
                return decodedValue
            }
            return nil
        }
        set {
            if let value = newValue {
                let encodedData = try? JSONEncoder().encode(value)
                set(encodedData, forKey: .currentLocation)
                synchronize()
            }
        }
    }
    
    var appUnit: String? {
        get {
            return value(forKey: .appUnit) as? String
        }
        set {
            set(newValue, forKey: .appUnit)
            synchronize()
        }
    }
}

extension String {
    static let currentLocation     = "currentLocationForecast"
    static let appUnit             = "appUnit"
}
