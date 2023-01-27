//
//  AudioRequest.swift
//  
//
//  Created by Guilherme Domingues on 27/01/23.
//

import Foundation

struct AudioRequest: Codable {
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
