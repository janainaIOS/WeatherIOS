//
//  Forecast.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation

struct Forecast: Codable {
    var city = City()
    var list: [Weather] = []
    var isHome = false
    
    init () {}
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        city = try (container.decodeIfPresent(City.self, forKey: .city) ?? City())
        list = try (container.decodeIfPresent([Weather].self, forKey: .list) ?? [])
    }
}

struct City: Codable {
    var id: Int = 0
    var name: String = ""
    var coord: LocCordinate?
    var sunrise: Double = 0
    var sunset: Double = 0
    var timezone: Int = 0
    var isHome = false
    
    init () {}
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        name = try (container.decodeIfPresent(String.self, forKey: .name) ?? "")
        coord = try (container.decodeIfPresent(LocCordinate.self, forKey: .coord) ?? LocCordinate())
        sunrise = try (container.decodeIfPresent(Double.self, forKey: .sunrise) ?? 0)
        sunset = try (container.decodeIfPresent(Double.self, forKey: .sunset) ?? 0)
        timezone = try (container.decodeIfPresent(Int.self, forKey: .timezone) ?? 0)
    }
}
