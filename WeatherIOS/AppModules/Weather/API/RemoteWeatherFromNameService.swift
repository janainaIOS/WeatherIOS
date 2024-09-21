//
//  RemoteWeatherFromNameService.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation

/// service for weather details using location name
final class RemoteWeatherFromNameService: WeatherFromNameService {

    func load(request: WeatherFromNameRequest, completion: @escaping Completion) {
        NetworkManager.loadData(request: request, parameters: request, completion: completion)
    }
}
