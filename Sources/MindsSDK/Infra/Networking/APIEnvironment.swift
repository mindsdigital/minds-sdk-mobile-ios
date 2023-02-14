//
//  Environment.swift
//  
//
//  Created by Vinicius Salmont on 05/05/22.
//

import Foundation

enum APIEnvironment: String, CaseIterable {
    case sandbox
    case staging
    case production
}

extension APIEnvironment {
    
    var _baseURL: [String: String] {
        switch self {
        case .sandbox:
            return ["SPEAKER_API": "https://sandbox-speaker-api.minds.digital","VOICE_API": "https://sandbox-voice-api.minds.digital"]
        case .staging:
            return ["SPEAKER_API": "https://staging-speaker-api.minds.digital","VOICE_API": "https://staging-voice-api.minds.digital"]
        case .production:
            return ["SPEAKER_API": "https://speaker-api.minds.digital","VOICE_API": "https://voice-api.minds.digital"]
        }
    }
    
    var speakerApi: String {
        return _baseURL["SPEAKER_API"] ?? ""
    }
    var voiceApi: String {
        return _baseURL["VOICE_API"] ?? ""
    }
    
    var currentEnvironment: String {
        switch self {
        case .sandbox:
            return APIEnvironment.sandbox.rawValue
        case .staging:
            return APIEnvironment.staging.rawValue
        case .production:
            return APIEnvironment.production.rawValue
        }
    }
}
