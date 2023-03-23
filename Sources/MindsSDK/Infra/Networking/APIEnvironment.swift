//
//  Environment.swift
//  
//
//  Created by Vinicius Salmont on 05/05/22.
//

import Foundation

public enum Environment: String {
    case sandbox
    case staging
    case production
}

class EnvironmentManager {
    
    static let shared = EnvironmentManager()
    
    private var currentEnvironment: Environment = .sandbox
    
    func setEnvironment(_ environment: Environment) {
         currentEnvironment = environment
     }
    
    func _baseURL() -> [String: String] {
        switch currentEnvironment {
        case .sandbox:
            return ["SPEAKER_API": "https://sandbox-speaker-api.minds.digital","VOICE_API": "https://sandbox-voice-api.minds.digital"]
        case .staging:
            return ["SPEAKER_API": "https://staging-speaker-api.minds.digital","VOICE_API": "https://staging-voice-api.minds.digital"]
        case .production:
            return ["SPEAKER_API": "https://speaker-api.minds.digital","VOICE_API": "https://voice-api.minds.digital"]
        }
    }
    
    var speakerApi: String {
        return _baseURL()["SPEAKER_API"] ?? ""
    }
    var voiceApi: String {
        return _baseURL()["VOICE_API"] ?? ""
    }
    
    func getCurrentEnvironment() -> Environment {
        return currentEnvironment
    }
}
