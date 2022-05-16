//
//  BiometricsEndpoints.swift
//  
//
//  Created by Vinicius Salmont on 05/05/22.
//

import Foundation
import Alamofire

typealias Headers = [String: String]

enum BiometricsEndpoints {
    
    case biometrics(requestBody: AudioRequest)
    
    var requestTimeOut: Int {
        return 20
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .biometrics:
            return .POST
        }
    }
    
    func createRequest(token: String, environment: APIEnvironment) -> NetworkRequest {
        var headers: Headers = [:]
        headers["Content-Type"] = "application/json"
        headers["authorization"] = "Bearer \(token)"
        return NetworkRequest(url: getURL(from: environment), headers: headers, body: requestBody, httpMethod: httpMethod)
    }
    
    var requestBody: Encodable? {
        switch self {
        case .biometrics(let request):
            return request
        }
    }
    
    func getURL(from environment: APIEnvironment) -> String {
        let baseUrl = environment.baseURL
        switch self {
        case .biometrics:
            return "\(baseUrl)/v2/biometrics"
        }
    }
}
