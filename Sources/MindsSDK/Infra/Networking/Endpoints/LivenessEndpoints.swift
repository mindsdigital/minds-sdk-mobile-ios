//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 03/07/22.
//

import Foundation
import Alamofire

enum LivenessEndpoints {
    
    case randomSentences
    
    var requestTimeOut: Int {
        return 20
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .randomSentences:
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
        case .randomSentences:
            return nil
        }
    }
    
    func getURL() -> String {
        let baseUrl = EnvironmentManager.shared.speakerApi
        switch self {
        case .randomSentences:
            return "\(baseUrl)/v2/liveness/random-sentence"
        }
    }
}
