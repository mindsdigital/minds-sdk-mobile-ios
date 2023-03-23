//
//  File.swift
//  
//
//  Created by Wennys on 18/01/23.
//

import Foundation


import Foundation
import Alamofire

enum VoiceApiEndpoints {
    
    case authentication(requestBody: AudioRequest)
    case enrollment(requestBody: AudioRequest)
    case setryDsn
    
    var httpMethod: HTTPMethod {
        switch self {
        case .authentication, .enrollment:
            return .POST
        case .setryDsn:
            return .GET
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
        case .authentication(let request):
            return request
        case .enrollment(let request):
            return request
        case .setryDsn:
            return nil
        }
    }
    
    func getURL() -> String {
        let baseUrl = EnvironmentManager.shared.voiceApi
        switch self {
        case .authentication:
            return "\(baseUrl)/v2.1/authentication"
        case .enrollment:
            return "\(baseUrl)/v2.1/enrollment"
        case .setryDsn:
            return "\(baseUrl)/trial-api/external/system-config/app-dsn?systemOS=ios"
        }
    }
}
