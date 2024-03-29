//
//  DsnUrlResponse.swift
//  
//
//  Created by Wennys on 14/02/23.
//

struct DsnUrlResponse: Codable {
    let success: Bool
    let message: String?
    let data: String
    let requestHasValidationErrors: Bool?
    let status: String?
    
    init(success: Bool = false, message: String?, data: String = "", requestHasValidationErrors: Bool?, status: String?) {
        self.success = success
        self.message = message
        self.data = data
        self.requestHasValidationErrors = requestHasValidationErrors
        self.status = status
    }

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
        case requestHasValidationErrors
        case status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        data = try container.decode(String.self, forKey: .data)
        requestHasValidationErrors = try container.decodeIfPresent(Bool.self, forKey: .requestHasValidationErrors)
        status = try container.decodeIfPresent(String.self, forKey: .status)
    }
}
