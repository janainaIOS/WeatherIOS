//
//  String+Extensions.swift
//  WeatherIOS
//
//  Created by Janaina A on 21/09/2024.
//

import Foundation

extension String {
    
    /// Here we are converting date string in one format to given output format
    /// today -> true, will check date is today and return "Today"
    func formatDate(inputFormat: dateFormat, outputFormat: dateFormat, today: Bool = false)-> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputFormat.rawValue
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = outputFormat.rawValue
        
        if let dateStr = dateFormatterGet.date(from: self) {
            if today && Calendar.current.isDateInToday(dateStr) {
                return "Today"
            }
            return dateFormatterPrint.string(from: dateStr)
        } else {
            print("There was an error decoding the string")
            return ""
        }
    }
    
    func formatToDate(inputFormat: dateFormat) -> Date? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputFormat.rawValue
        return dateFormatterGet.date(from: self)
    }
}
