//
//  NetworkManager.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import Foundation
import Alamofire

public struct NetworkManager {
    
    static func loadData<T: Encodable, U: Decodable>(
        request: NetworkRequest,
        parameters: T?,
        completion: @escaping (
            Result<U, CustomError>
        ) -> Void
    ) {
        if Connectivity.isConnectedToInternet() {
            print("[Request] :==> \(request.httpMethod.rawValue)  \(request.url)")
            
            AF.request(
                request.url,
                method: request.httpMethod,
                parameters: parameters,
                encoder: request.encoding,
                headers: request.headers
            )
            .validate(statusCode: 200...407)
            .responseDecodable(of: U.self) { response in
               
                
                switch response.result {
                case .success(_):
                    completion(.success(response.value!))
                case .failure(let error):
                    print("[Error] :==> \(error)")
                    completion(.failure(.general(message: error.localizedDescription)))
                }
            }
        } else {
            completion(.failure(.noNetwork))
            return
        }
    }
    
    
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

enum CustomError: Error {
    case unknown
    case noData
    case noNetwork
    case general(message: String)
    
    var description: String {
        switch self {
        case .noNetwork:
            return AlertMessages.networkAlert
        case .unknown:
            return AlertMessages.somethingWentWrong
        case .noData:
            return AlertMessages.somethingWentWrong
        case .general(let message):
            return message
        }
    }
}

