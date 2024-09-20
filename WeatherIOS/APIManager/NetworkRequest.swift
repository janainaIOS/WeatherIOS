//
//  NetworkRequest.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation
import Alamofire

protocol NetworkRequest {
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: String { get }
    var encoding: ParameterEncoder { get }
}
