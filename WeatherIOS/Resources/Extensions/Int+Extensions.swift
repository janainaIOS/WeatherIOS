//
//  Int+Extensions.swift
//  WeatherIOS
//
//  Created by Janaina A on 21/09/2024.
//


import Foundation

extension Int {
    /// Here we are converting date from Int format to given output format date string
    func formatDateString(outputFormat: dateFormat) -> String {
        let date = formatDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat.rawValue
        let timeZone = TimeZone(secondsFromGMT: self)
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    func formatDate() -> Date {
        let timestamp: TimeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: timestamp)
        return date
    }
    
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
