//
//  WeatherFromNameService.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation

/// service for weather details using location name
protocol WeatherFromNameService: AnyObject {
    typealias Completion = (Result<Weather, CustomError>) -> Void
    
    func load(request: WeatherFromNameRequest, completion: @escaping Completion)
}
