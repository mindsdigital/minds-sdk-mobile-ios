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
    
    case validateDataInput(requestBody: ValidateInputRequest)
    
    var httpMethod: HTTPMethod {
        switch self {
        case .validateDataInput:
            return .POST
        }
    }
    
    func createRequest(token: String) -> NetworkRequest {
        var headers: Headers = [:]
        headers["Content-Type"] = "application/json"
        headers["authorization"] = "Bearer \(token)"
        return NetworkRequest(url: getURL(), headers: headers, body: requestBody, httpMethod: httpMethod)
    }
    
    var requestBody: Encodable? {
        switch self {
        case .validateDataInput(let request):
            return request
        }
    }
    
    func getURL() -> String {
        let baseUrl = EnvironmentManager.shared.speakerApi
        switch self {
        case .validateDataInput:
            return "\(baseUrl)/v2/biometrics/validate-sdk-init"
        }
    }
}
