//
//  RandomSentence.swift
//  
//
//  Created by Guilherme Domingues on 27/01/23.
//

import Foundation

struct RandomSentenceResponse: Codable {
    let success: Bool
    let data: RandomSentenceModel
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
    }
}

struct RandomSentenceModel: Codable {
    let id: Int
    let text: String

    enum CodingKeys: String, CodingKey {
        case id
        case text
    }
}
