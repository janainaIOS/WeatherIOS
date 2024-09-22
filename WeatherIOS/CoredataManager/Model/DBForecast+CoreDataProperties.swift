//
//  DBForecast+CoreDataProperties.swift
//  WeatherIOS
//
//  Created by Janaina A on 22/09/2024.
//
//

import Foundation
import CoreData


extension DBForecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBForecast> {
        return NSFetchRequest<DBForecast>(entityName: "DBForecast")
    }

    @NSManaged public var id: Int64
    @NSManaged public var isHome: Bool
    @NSManaged public var timezone: Int64
    @NSManaged public var forecasts: NSSet?

}

// MARK: Generated accessors for forecasts
extension DBForecast {

    @objc(addForecastsObject:)
    @NSManaged public func addToForecasts(_ value: DBWeather)

    @objc(removeForecastsObject:)
    @NSManaged public func removeFromForecasts(_ value: DBWeather)

    @objc(addForecasts:)
    @NSManaged public func addToForecasts(_ values: NSSet)

    @objc(removeForecasts:)
    @NSManaged public func removeFromForecasts(_ values: NSSet)

}

extension DBForecast : Identifiable {

}
