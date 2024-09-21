//
//  DBWeather+CoreDataProperties.swift
//  WeatherIOS
//
//  Created by Janaina A on 21/09/2024.
//
//

import Foundation
import CoreData


extension DBWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBWeather> {
        return NSFetchRequest<DBWeather>(entityName: "DBWeather")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var date: String?
    @NSManaged public var descriptn: String?
    @NSManaged public var descriptnMain: String?
    @NSManaged public var humidity: Double
    @NSManaged public var id: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var maxTemp: Double
    @NSManaged public var minTemp: Double
    @NSManaged public var pressure: Double
    @NSManaged public var sunrise: Double
    @NSManaged public var sunset: Double
    @NSManaged public var temp: Double
    @NSManaged public var windSpeed: Double
    @NSManaged public var isHome: Bool
    @NSManaged public var forecast: DBForecast?

}

extension DBWeather : Identifiable {

}
