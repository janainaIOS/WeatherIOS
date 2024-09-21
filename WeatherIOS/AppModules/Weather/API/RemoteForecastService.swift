//
//  RemoteForecastService.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation

/// service for forecast details using location coordinates
final class RemoteForecastService: ForecastService {

    func load(request: ForecastRequest, completion: @escaping Completion) {
        NetworkManager.loadData(request: request, parameters: request, completion: completion)
    }
}
