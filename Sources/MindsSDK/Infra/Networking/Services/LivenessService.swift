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
    private var env: APIEnvironment
    
    init(networkRequest: Requestable, env: APIEnvironment = .sandbox) {
        self.networkRequest = networkRequest
        self.env = env
    }

    func getRandomSentence(token: String, completion: @escaping (Result<RandomSentenceResponse, NetworkError>) -> Void) {
        let endpoint = LivenessEndpoints.randomSentences
        let request = endpoint.createRequest(token: token, environment: env)
        self.networkRequest.request(request) { result in
            completion(result)
        }
    }
}
