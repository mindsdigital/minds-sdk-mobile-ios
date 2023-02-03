//
//  RandomSentenceId.swift
//  
//
//  Created by Guilherme Domingues on 27/01/23.
//

import Foundation

struct RandomSentenceId: Codable {
    let id: Int
    let result: String?

    init(id: Int, result: String? = nil) {
        self.id = id
        self.result = result
    }

    enum CodingKeys: String, CodingKey {
        case id = "sentence_id"
        case result
    }
}

struct RandomSentenceIdResponse: Codable {
    let id: Int
    let result: String?

    init(id: Int, result: String? = nil) {
        self.id = id
        self.result = result
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case result
    }
}
