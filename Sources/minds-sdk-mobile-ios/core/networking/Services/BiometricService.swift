//
//  BiometricService.swift
//  
//
//  Created by Vinicius Salmont on 05/05/22.
//

import Foundation

protocol BiometricProtocol {
    func sendAudio(token: String, request: AudioRequest, completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void)
}

class BiometricServices: BiometricProtocol {
    private var networkRequest: Requestable
    private var env: APIEnvironment = .sandbox
    
    init(networkRequest: Requestable, env: APIEnvironment) {
        self.networkRequest = networkRequest
        self.env = env
    }
    
    func sendAudio(token: String, request: AudioRequest, completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void) {
        let endpoint = BiometricsEndpoints.biometrics(requestBody: request)
        let request = endpoint.createRequest(token: token, environment: env)
        self.networkRequest.request(request) { result in
            completion(result)
        }
    }
}

struct AudioRequest: Codable {
    let cpf: String
    let phoneNumber: String
    let externalCostumerID: String
    let audioFiles: [AudioFile]
    
    enum CodingKeys: String, CodingKey {
        case cpf
        case phoneNumber = "phone_number"
        case externalCostumerID = "external_customer_id"
        case audioFiles = "audio"
    }
}

struct AudioFile: Codable {
    let fileExtension: String
    let content: String
    let rate: String
    
    
    enum CodingKeys: String, CodingKey {
        case fileExtension = "extension"
        case content
        case rate
    }
}

struct BiometricResponse: Codable {
    let id: Int64?
    let cpf: String?
    let verificationID: Int64?
    let action: String?
    let externalId: Int64?
    let status: String?
    let createdAt: Date?
    let success: Bool?
    let whitelisted: Bool?
    let fraudRisk: String?
    let enrollmentExternalId: Int64?
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
