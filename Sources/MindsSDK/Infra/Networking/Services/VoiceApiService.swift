//
//  File.swift
//  
//
//  Created by Wennys on 18/01/23.
//


public protocol VoiceApiProtocol {
    func sendAudio(token: String, request: AudioRequest, completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void)
}

class VoiceApiServices: VoiceApiProtocol {
    private var networkRequest: Requestable
    private var env: APIEnvironment
    
    init(networkRequest: Requestable, env: APIEnvironment = .sandbox) {
        self.networkRequest = networkRequest
        self.env = env
    }
    
    func sendAudio(token: String, request: AudioRequest,
                   completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void) {
        var endpoint: VoiceApiEndpoints
        if(SDKDataRepository.shared.processType.rawValue ==  MindsSDK.ProcessType.authentication.rawValue){
            endpoint = VoiceApiEndpoints.authentication(requestBody: request)
        }else {
            endpoint = VoiceApiEndpoints.enrollment(requestBody: request)
        }
        let request = endpoint.createRequest(token: token, environment: env)
        self.networkRequest.request(request) { result in
            completion(result)
        }
    }
}

public struct AudioRequest: Codable {
    let audios: String
    let cpf: String
    let externalId: String
    let externalCustomerID: String
    let extensionAudio: String
    let phoneNumber: String
    let showDetails: Bool
    let sourceName: String
    
    enum CodingKeys: String, CodingKey {
        case cpf
        case externalId = "external_id"
        case phoneNumber = "phone_number"
        case externalCustomerID = "external_customer_id"
        case audios = "audio"
        case extensionAudio = "extension"
        case showDetails = "show_details"
        case sourceName = "source_name"
    }
}

public struct BiometricResponse: Codable {
    public var success: Bool?
    public var error: ErrorResponse?
    public let id: Int64?
    public let cpf: String?
    public let externalID: String?
    public let createdAt: String?
    public let result: ResultAction?
    public let details: Details?
    
    public init(success: Bool? = nil, error: ErrorResponse? = nil, id: Int64? = nil, cpf: String? = nil, externalID: String? = nil, createdAt: String? = nil, result: ResultAction? = nil, details: Details? = nil) {
        self.success = success
        self.error = error
        self.id = id
        self.cpf = cpf
        self.externalID = externalID
        self.createdAt = createdAt
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
    
    enum CodingKeys: String, CodingKey {
        case flag
        case voiceMatch = "voice_match"
    }
    
    public let flag: Flag?
    public let voiceMatch: VoiceMatch?
    
    public struct Flag: Codable {
        public let id: Int64
        public let type: String
        public let description: String
        public let status: String
    }
    
    public struct VoiceMatch: Codable {
        public let result: String
        public let confidence: String
        public let status: String
    }
}

public struct ErrorResponse: Codable {
    public var code: String
    public var description: String
}

