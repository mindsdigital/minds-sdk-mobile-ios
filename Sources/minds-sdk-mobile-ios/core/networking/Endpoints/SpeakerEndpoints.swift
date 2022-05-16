//
//  SpeakerEndpoints.swift
//  
//
//  Created by Vinicius Salmont on 16/05/22.
//

import Foundation
import Alamofire

enum SpeakerEndpoints {

    case validateFormat(requestBody: ValidateFormatRequest)

    var requestTimeOut: Int {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .validateFormat:
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
        case .validateFormat(let request):
            return request
        }
    }

    func getURL(from environment: APIEnvironment) -> String {
        let baseUrl = environment.baseURL
        switch self {
        case .validateFormat:
            return "\(baseUrl)/speaker/validate-audio-format"
        }
    }
}
