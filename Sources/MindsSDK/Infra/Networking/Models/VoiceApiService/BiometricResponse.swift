//
//  BiometricResponse.swift
//  
//
//  Created by Guilherme Domingues on 27/01/23.
//

import Foundation

public struct BiometricResponse: Codable {
    public var success: Bool?
    public var error: ErrorResponse?
    public let id: Int64?
    public let cpf: String?
    public let externalID: String?
    public let createdAt: String?
    public let utcCreatedAt: String?
    public let result: ResultAction?
    public let details: Details?
    
    public init(success: Bool? = nil, error: ErrorResponse? = nil, id: Int64? = nil, cpf: String? = nil, externalID: String? = nil, createdAt: String? = nil, utcCreatedAt: String? = nil, result: ResultAction? = nil, details: Details? = nil) {
        self.success = success
        self.error = error
        self.id = id
        self.cpf = cpf
        self.externalID = externalID
        self.createdAt = createdAt
        self.utcCreatedAt = utcCreatedAt
        self.result = result
        self.details = details
    }
    
    enum CodingKeys: String, CodingKey {
        case success
        case error
        case id
        case cpf
        case externalID = "external_id"
        case createdAt = "created_at"
        case utcCreatedAt = "utc_created_at"
        case result
        case details
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        error = try container.decodeIfPresent(ErrorResponse?.self, forKey: .error) ?? nil
        id = try container.decodeIfPresent(Int64?.self, forKey: .id) ?? nil
        cpf = try container.decodeIfPresent(String?.self, forKey: .cpf) ?? nil
        externalID = try container.decodeIfPresent(String?.self, forKey: .externalID) ?? nil
        createdAt = try container.decodeIfPresent(String?.self, forKey: .createdAt) ?? nil
        utcCreatedAt = try container.decodeIfPresent(String?.self, forKey: .utcCreatedAt) ?? nil
        result = try container.decodeIfPresent(ResultAction?.self, forKey: .result) ?? nil
        details = try container.decodeIfPresent(Details?.self, forKey: .details) ?? nil
    }
}

public struct ResultAction: Codable {
    public let recommendedAction: String
    public let reasons: [String]
    
    enum CodingKeys: String, CodingKey {
        case recommendedAction = "recommended_action"
        case reasons
    }
}

public struct Details: Codable {
    
    public let flag: Flag?
    public let liveness: LivenessResponse?
    public let antispoofing: Antispoofing?
    public let voiceMatch: VoiceMatch?
    
    public struct Flag: Codable {
        public let type: String?
        public let status: String?
    }
    
    public class DetectionResult: Codable {
        public let status: String?
        public let result: String?
        public let confidence: String?
        public let score: Double?
        public let threshold: Double?
    }
    
    public class VoiceMatch: DetectionResult {}
    
    public struct LivenessResponse: Codable {
        public let status: String?
        public let replayAttack: ReplayAttack?
        public let deepFake: DeepFake?
        public let sentenceMatch: SentenceMatch?
        
        public class ReplayAttack: DetectionResult {
            public let enabled: Bool = false
        }
        public class DeepFake: DetectionResult {
            public let enabled: Bool = false
        }
        public class SentenceMatch: DetectionResult {
            public let enabled: Bool = false
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case replayAttack = "replay_attack"
            case deepFake = "deepfake"
            case sentenceMatch = "sentence_match"
        }  
    }
    public struct Antispoofing: Codable {
        public let result: String?
        public let status: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case flag
        case liveness
        case antispoofing
        case voiceMatch = "voice_match"
    }
}

public struct ErrorResponse: Codable {
    public let code: String
    public let description: String
}
