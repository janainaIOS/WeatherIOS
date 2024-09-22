//
//  Weather.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation

struct Weather: Codable {
    var id: Int = 0
    var cityName: String = ""
    var country: String = ""
    var cordinate: LocCordinate?
    var temparature: Temparature?
    var sys: Sys? = nil
    var descriptn: [Descriptn] = []
    var wind: Wind? = nil
    var dateTime: String = ""
    var isHome = false
    
    enum CodingKeys: String, CodingKey {
        case id, country, wind, sys
        case cityName = "name"
        case cordinate = "coord"
        case temparature = "main"
        case descriptn = "weather"
        case dateTime = "dt_txt"
    }
    
    init () {}
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        cityName = try (container.decodeIfPresent(String.self, forKey: .cityName) ?? "")
        country = try (container.decodeIfPresent(String.self, forKey: .country) ?? "")
        
        cordinate = try (container.decodeIfPresent(LocCordinate.self, forKey: .cordinate) ?? LocCordinate())
        temparature = try (container.decodeIfPresent(Temparature.self, forKey: .temparature) ?? Temparature())
        sys = try (container.decodeIfPresent(Sys.self, forKey: .sys) ?? Sys())
        descriptn = try (container.decodeIfPresent([Descriptn].self, forKey: .descriptn) ?? [])
         wind = try (container.decodeIfPresent(Wind.self, forKey: .wind) ?? Wind())
        dateTime = try (container.decodeIfPresent(String.self, forKey: .dateTime) ?? "")
    }
}

struct LocCordinate: Codable {
    var longitude: Double?
    var latitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

struct Temparature: Codable {
    var temp: Double?
    var minTemp: Double?
    var maxTemp: Double?
    var humidity: Double?
    var pressure: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity, pressure
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}

struct Descriptn: Codable {
    var description: String?
    var main: String?
}

struct Wind: Codable {
    var speed: Double?
}

struct Sys: Codable {
    var sunrise: Double?
    var sunset: Double?
}

