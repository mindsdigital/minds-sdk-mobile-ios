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
    let externalCustomerID: String
    let audios: [AudioFile]
    let liveness: RandomSentenceId
    
    enum CodingKeys: String, CodingKey {
        case action
        case cpf
        case phoneNumber = "phone_number"
        case externalCustomerID = "external_customer_id"
        case audios = "audio"
        case liveness
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

struct AudioFile: Codable {
    let content: String
    let `extension`: String = "ogg"
}

public struct BiometricResponse: Codable {
    public let id: Int64?
    public let cpf: String?
    public let verificationID: Int64?
    public let action: String?
    public let externalId: String?
    public var status: String?
    public let createdAt: String?
    public let success: Bool
    public let whitelisted: Bool?
    public let fraudRisk: String?
    public let enrollmentExternalId: String?
    public let matchPrediction: String?
    public let confidence: String?
    public let message: String?
    public let numberOfRetries: Int?
    public let flag: Flag?
    public let liveness: [RandomSentenceId]?

    public init(id: Int64? = nil, cpf: String? = nil, verificationID: Int64? = nil,
                action: String? = nil, externalId: String? = nil, status: String? = nil,
                createdAt: String? = nil, success: Bool, whitelisted: Bool? = nil,
                fraudRisk: String? = nil, enrollmentExternalId: String? = nil,
                matchPrediction: String? = nil, confidence: String? = nil,
                message: String? = nil, numberOfRetries: Int? = nil, flag: Flag? = nil,
                liveness: [RandomSentenceId]? = nil) {
        self.id = id
        self.cpf = cpf
        self.verificationID = verificationID
        self.action = action
        self.externalId = externalId
        self.status = status
        self.createdAt = createdAt
        self.success = success
        self.whitelisted = whitelisted
        self.fraudRisk = fraudRisk
        self.enrollmentExternalId = enrollmentExternalId
        self.matchPrediction = matchPrediction
        self.confidence = confidence
        self.message = message
        self.numberOfRetries = numberOfRetries
        self.flag = flag
        self.liveness = liveness
    }

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
        case numberOfRetries = "number_of_retries"
        case flag
        case liveness
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int64?.self, forKey: .id) ?? nil
        cpf = try container.decodeIfPresent(String?.self, forKey: .cpf) ?? nil
        verificationID = try container.decodeIfPresent(Int64?.self, forKey: .verificationID) ?? nil
        action = try container.decodeIfPresent(String?.self, forKey: .action) ?? nil
        externalId = try container.decodeIfPresent(String?.self, forKey: .externalId) ?? nil
        status = try container.decodeIfPresent(String?.self, forKey: .status) ?? nil
        createdAt = try container.decodeIfPresent(String?.self, forKey: .createdAt) ?? nil
        success = try container.decode(Bool.self, forKey: .success)
        whitelisted = try container.decodeIfPresent(Bool?.self, forKey: .whitelisted) ?? nil
        fraudRisk = try container.decodeIfPresent(String?.self, forKey: .fraudRisk) ?? nil
        enrollmentExternalId = try container.decodeIfPresent(String?.self, forKey: .enrollmentExternalId) ?? nil
        matchPrediction = try container.decodeIfPresent(String?.self, forKey: .matchPrediction) ?? nil
        confidence = try container.decodeIfPresent(String?.self, forKey: .confidence) ?? nil
        message = try container.decodeIfPresent(String?.self, forKey: .message) ?? nil
        numberOfRetries = try container.decodeIfPresent(Int?.self, forKey: .numberOfRetries) ?? nil
        flag = try container.decodeIfPresent(Flag?.self, forKey: .flag) ?? nil
        liveness = try container.decodeIfPresent([RandomSentenceId]?.self, forKey: .liveness) ?? nil
    }
}

public struct Flag: Codable {
    public let id: Int
    public let type: String
    public let description: String
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
