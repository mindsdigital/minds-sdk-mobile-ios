//
//  SpeakerServices.swift.swift
//  
//
//  Created by Vinicius Salmont on 16/05/22.
//

import Foundation

protocol SpeakerProtocol {
    func validateAudioFormat(token: String, request: ValidateFormatRequest, completion: @escaping (Result<ValidateFormatResponse, NetworkError>) -> Void)
}

class SpeakerServices: SpeakerProtocol {
    private var networkRequest: Requestable
    private var env: APIEnvironment

    init(networkRequest: Requestable, env: APIEnvironment = .sandbox) {
        self.networkRequest = networkRequest
        self.env = env
    }

    func validateAudioFormat(token: String, request: ValidateFormatRequest, completion: @escaping (Result<ValidateFormatResponse, NetworkError>) -> Void) {
        let endpoint = SpeakerEndpoints.validateFormat(requestBody: request)
        let request = endpoint.createRequest(token: token, environment: env)
        self.networkRequest.request(request) { result in
            completion(result)
        }
    }
}

struct ValidateFormatRequest: Codable {
    let fileExtension: String
    let rate: Int

    enum CodingKeys: String, CodingKey {
        case fileExtension = "extension"
        case rate
    }
}

struct ValidateFormatResponse: Codable {
    let status: String?
    let success: Bool
    let isValid: Bool

    enum CodingKeys: String, CodingKey {
        case status
        case success
        case isValid = "is_valid"
    }
}
