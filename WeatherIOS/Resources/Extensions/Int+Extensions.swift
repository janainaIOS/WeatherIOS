//
//  Int+Extensions.swift
//  WeatherIOS
//
//  Created by Janaina A on 21/09/2024.
//


import Foundation

extension Int {
    /// Here we are getting current time from timezone
     func getCurrentTime(outputFormat: dateFormat) -> String? {
         let currentDate = Date()
         
         // Calculate the time zone
         let timeZone = TimeZone(secondsFromGMT: self)
         
         // Create a DateFormatter to format the date according to the specified timezone
         let dateFormatter = DateFormatter()
         dateFormatter.timeZone = timeZone
         dateFormatter.dateFormat = outputFormat.rawValue
         
         return dateFormatter.string(from: currentDate)
     }
}
