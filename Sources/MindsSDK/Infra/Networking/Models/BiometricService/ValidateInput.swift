//
//  ValidateInput.swift
//  
//
//  Created by Guilherme Domingues on 27/01/23.
//

import Foundation

struct ValidateInputRequest: Codable {
    let document: Document
    let checkForVerification: Bool
    let phoneNumber: String
    let phoneCountryCode: Int?
    let rate: Int

    enum CodingKeys: String, CodingKey {
        case document
        case checkForVerification = "check_for_verification"
        case phoneNumber = "phone_number"
        case phoneCountryCode = "phone_country_code"
        case rate
    }
}

struct ValidateInputResponse: Codable {
    let success: Bool
    let message: String?
    let result: Bool?
    let status: String
}
