//
//  File.swift
//  
//
//  Created by Wennys on 09/01/24.
//

import Foundation

struct Document: Codable {
    let value: String

    enum CodingKeys: String, CodingKey {
        case value
    }
}
