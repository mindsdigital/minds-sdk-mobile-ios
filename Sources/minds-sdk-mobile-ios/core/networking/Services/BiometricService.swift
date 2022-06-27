//
//  BiometricService.swift
//  
//
//  Created by Vinicius Salmont on 05/05/22.
//

import Foundation

protocol BiometricProtocol {
    func sendAudio(token: String, request: AudioRequest, completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void)
    func validateInput(token: String, request: ValidateInputRequest, completion: @escaping (Result<ValidateInputResponse, NetworkError>) -> Void)
}

class BiometricServices: BiometricProtocol {
    private var networkRequest: Requestable
    private var env: APIEnvironment
    
    init(networkRequest: Requestable, env: APIEnvironment = .staging) {
        self.networkRequest = networkRequest
        self.env = env
    }
    
    func sendAudio(token: String, request: AudioRequest,
                   completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void) {
        let endpoint = BiometricsEndpoints.biometrics(requestBody: request)
        let request = endpoint.createRequest(token: token, environment: env)
        self.networkRequest.request(request) { result in
            completion(result)
        }
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

struct AudioRequest: Codable {
    let action: String
    let cpf: String
    let phoneNumber: String
    let externalCostumerID: String
    let audios: [AudioFile]
    
    enum CodingKeys: String, CodingKey {
        case action
        case cpf
        case phoneNumber = "phone_number"
        case externalCostumerID = "external_customer_id"
        case audios = "audio"
    }
}

struct AudioFile: Codable {
    let content: String
    let `extension`: String = "wav"
}

struct BiometricResponse: Codable {
    let id: Int64?
    let cpf: String?
    let verificationID: Int64?
    let action: String?
    let externalId: String?
    let status: String?
    let createdAt: String?
    let success: Bool
    let whitelisted: Bool?
    let fraudRisk: String?
    let enrollmentExternalId: String?
    let matchPrediction: String?
    let confidence: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case cpf
        case verificationID = "verification_id"
        case action
        case externalId = "external_id"
        case status
        case createdAt = "created_at"
        case success
        case whitelisted
        case fraudRisk = "fraud_risk"
        case enrollmentExternalId = "enrollment_external_id"
        case matchPrediction = "match_prediction"
        case confidence
        case message
    }
}

struct ValidateInputRequest: Codable {
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

struct ValidateInputResponse: Codable {
    let success: Bool
    let message: String?
    let result: Bool?
    let status: String
}
