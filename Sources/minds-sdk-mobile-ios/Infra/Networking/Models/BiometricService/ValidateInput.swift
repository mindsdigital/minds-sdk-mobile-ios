//
//  ValidateInput.swift
//  
//
//  Created by Guilherme Domingues on 27/01/23.
//

import Foundation

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
