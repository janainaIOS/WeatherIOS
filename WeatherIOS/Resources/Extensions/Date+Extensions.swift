//
//  Date+Extensions.swift
//  WeatherIOS
//
//  Created by Janaina A on 21/09/2024.
//

import Foundation

extension Date {
    /// Here we are converting date in Date format to given output format date string
    func formatDate(outputFormat: dateFormat)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat.rawValue
        return dateFormatter.string(from: self)
    }
    
    func formatLocationTimeZone(locationTimeZone: TimeZone) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = locationTimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Convert the current date to a string in the location's time zone
        let currentTimeString = dateFormatter.string(from: Date())
        
        
        guard let localCurrentTime = dateFormatter.date(from: currentTimeString) else {
            print("Error converting current time to the location's timezone")
            return nil
        }
        
        return localCurrentTime
    }

}
