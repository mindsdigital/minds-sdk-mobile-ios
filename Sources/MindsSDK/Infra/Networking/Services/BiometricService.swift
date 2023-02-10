//
//  BiometricService.swift
//  
//
//  Created by Vinicius Salmont on 05/05/22.
//

import Foundation

protocol BiometricProtocol {
    func validateInput(token: String, request: ValidateInputRequest, completion: @escaping (Result<ValidateInputResponse, NetworkError>) -> Void)
}

class BiometricServices: BiometricProtocol {
    private var networkRequest: Requestable
    private var env: APIEnvironment
    
    init(networkRequest: Requestable, env: APIEnvironment = .sandbox) {
        self.networkRequest = networkRequest
        self.env = env
    }
    

    func validateInput(token: String, request: ValidateInputRequest, completion: @escaping (Result<ValidateInputResponse, NetworkError>) -> Void) {
        let endpoint = BiometricsEndpoints.validateDataInput(requestBody: request)
        let request = endpoint.createRequest(token: token, environment: env)
        self.networkRequest.request(request) { result in
            completion(result)
        }
    }
}
