//
//  Double+Extensions.swift
//  WeatherIOS
//
//  Created by Janaina A on 22/09/2024.
//

import Foundation

extension Double {
    /// Here we are converting date from Double format to given output format date string
    func formatDateString(outputFormat: dateFormat) -> String {
        let date = formatDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat.rawValue
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    func formatDate() -> Date {
        let timestamp: TimeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: timestamp)
        return date
    }
}
