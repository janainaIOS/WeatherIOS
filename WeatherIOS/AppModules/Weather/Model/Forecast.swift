//
//  Forecast.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation

struct Forecast: Codable {
    var city: City?
    let list: [Weather]?
    var isHome = false
}

struct City: Codable {
    var id: Int = 0
    var name: String = ""
    var coord: LocCordinate?
    var sunrise: Double = 0
    var sunset: Double = 0
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        name = try (container.decodeIfPresent(String.self, forKey: .name) ?? "")
        coord = try (container.decodeIfPresent(LocCordinate.self, forKey: .coord) ?? LocCordinate())
        sunrise = try (container.decodeIfPresent(Double.self, forKey: .sunrise) ?? 0)
        sunset = try (container.decodeIfPresent(Double.self, forKey: .sunset) ?? 0)
    }
}
