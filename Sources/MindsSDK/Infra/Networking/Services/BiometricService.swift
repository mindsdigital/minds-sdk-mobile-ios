//
//  BiometricService.swift
//  
//
//  Created by Vinicius Salmont on 05/05/22.
//

import Foundation

public protocol BiometricProtocol {
    func validateInput(token: String, request: ValidateInputRequest, completion: @escaping (Result<ValidateInputResponse, NetworkError>) -> Void)
}

class BiometricServices: BiometricProtocol {
    private var networkRequest: Requestable
    private var env: APIEnvironment
    
    init(networkRequest: Requestable, env: APIEnvironment = .sandbox) {
        self.networkRequest = networkRequest
        self.env = env
    }
    

    func validateInput(token: String, request: ValidateInputRequest,
                       completion: @escaping (Result<ValidateInputResponse, NetworkError>) -> Void) {
        let endpoint = BiometricsEndpoints.validateDataInput(requestBody: request)
        let request = endpoint.createRequest(token: token, environment: env)
        self.networkRequest.request(request) { result in
            completion(result)
        }
    }
}


public struct RandomSentenceId: Codable {
    public let id: Int
    public let result: String?

    public init(id: Int, result: String? = nil) {
        self.id = id
        self.result = result
    }

    enum CodingKeys: String, CodingKey {
        case id = "sentence_id"
        case result
    }
}

public struct RandomSentenceIdResponse: Codable {
    public let id: Int
    public let result: String?

    public init(id: Int, result: String? = nil) {
        self.id = id
        self.result = result
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case result
    }
}


public struct ValidateInputRequest: Codable {
    let cpf: String
    let fileExtension: String
    let checkForVerification: Bool
    let phoneNumber: String
    let rate: Int

    enum CodingKeys: String, CodingKey {
        case cpf
        case fileExtension = "extension"
        case checkForVerification = "check_for_verification"
        case phoneNumber = "phone_number"
        case rate
    }
}

public struct ValidateInputResponse: Codable {
    let success: Bool
    let message: String?
    let result: Bool?
    let status: String
}
