//
//  Enum.swift
//  WeatherIOS
//
//  Created by Janaina A on 21/09/2024.
//

import Foundation

/// Date and Time formats
enum dateFormat: String {
    case yyyyMMddHHmmss       = "yyyy-MM-dd HH:mm:ss"  // 2023-04-30 16:00:00
    case yyyyMMdd             = "yyyy-MM-dd"
    case ha                   = "ha"
    case hmma                 = "h:mm a"
    case eee                  = "EEE"
}

/// Enum representing different weather conditions and their associated SF Symbols.

enum WeatherCondition: String {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case drizzle = "Drizzle"
    case thunderstorm = "Thunderstorm"
    case snow = "Snow"
    case mist = "Mist"
    case smoke = "Smoke"
    case haze = "Haze"
    case dust = "Dust"
    case fog = "Fog"
    case sand = "Sand"
    case ash = "Ash"
    case squall = "Squall"
    case tornado = "Tornado"

    // Function to get corresponding SF Symbol for each weather condition
    var iconName: String {
        switch self {
        case .clear:
            return "sun.max.fill"              // ☀️ Clear sky
        case .clouds:
            return "cloud.fill"                // ☁️ Cloudy
        case .rain:
            return "cloud.rain.fill"           // 🌧️ Rain
        case .drizzle:
            return "cloud.drizzle.fill"        // 🌦️ Light Rain/Drizzle
        case .thunderstorm:
            return "cloud.bolt.rain.fill"      // ⛈️ Thunderstorm
        case .snow:
            return "snow"                      // ❄️ Snow
        case .mist, .fog, .haze:
            return "cloud.fog.fill"            // 🌫️ Mist/Fog/Haze
        case .smoke:
            return "smoke.fill"                // 🌀 Smoke
        case .dust, .sand:
            return "sun.dust.fill"             // 🌫️ Dust/Sand
        case .ash:
            return "cloud.fill"                // 🌋 Ash (Generic Cloud)
        case .squall:
            return "wind"                      // 🌪️ Squall
        case .tornado:
            return "tornado"                   // 🌪️ Tornado
        }
    }
}

/// Enum representing temparature units
enum Unit: String, CaseIterable {
    case metric = "Celsius (°C)"
    case imperial = "Fahrenheit (°F)"
    
}
