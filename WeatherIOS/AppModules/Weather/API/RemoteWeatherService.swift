//
//  RemoteWeatherService.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation

/// service for weather details using location coordinates
final class RemoteWeatherService: WeatherService {

    func load(request: WeatherRequest, completion: @escaping Completion) {
        NetworkManager.loadData(request: request, parameters: request, completion: completion)
    }
}
