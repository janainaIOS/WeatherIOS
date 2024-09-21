//
//  ForecastService.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation

/// service for forecast details using location coordinates
protocol ForecastService: AnyObject {
    typealias Completion = (Result<Forecast, CustomError>) -> Void
    
    func load(request: ForecastRequest, completion: @escaping Completion)
}
