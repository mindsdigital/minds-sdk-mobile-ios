//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 03/07/22.
//

import Foundation

protocol LivenessServiceProtocol {
    func getRandomSentence(token: String, completion: @escaping (Result<RandomSentenceResponse, NetworkError>) -> Void)
}

class LivenessService: LivenessServiceProtocol {
    private var networkRequest: Requestable
    
    init(networkRequest: Requestable) {
        self.networkRequest = networkRequest
    }

    func getRandomSentence(token: String, completion: @escaping (Result<RandomSentenceResponse, NetworkError>) -> Void) {
        let endpoint = LivenessEndpoints.randomSentences
        let request = endpoint.createRequest(token: token)
        self.networkRequest.request(request) { result in
            completion(result)
        }
    }
}
