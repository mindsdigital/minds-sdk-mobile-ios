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
    var baseURL: String {
        switch self {
        case .sandbox:
            return "https://sandbox-speaker-api.minds.digital"
        case .staging:
            return "https://staging-speaker-api.minds.digital"
        case .production:
            return "https://speaker-api.minds.digital"
        }
    }
}
