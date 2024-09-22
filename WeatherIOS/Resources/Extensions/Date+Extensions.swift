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
    
}
