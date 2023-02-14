//
//  File.swift
//  
//
//  Created by Wennys on 18/01/23.
//

import Foundation
import Sentry

protocol VoiceApiProtocol {
    func sendAudio(token: String, request: AudioRequest, completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void)
    func getDsn(token: String, completion: @escaping (Result<DsnUrlResponse, NetworkError>) -> Void)
}

class VoiceApiServices: VoiceApiProtocol {
    private var networkRequest: Requestable
    private var env: APIEnvironment
    
    init(networkRequest: Requestable, env: APIEnvironment = .sandbox) {
        self.networkRequest = networkRequest
        self.env = env
    }
    
    func sendAudio(token: String, request: AudioRequest,
                   completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void) {
        var endpoint: VoiceApiEndpoints
        if(SDKDataRepository.shared.processType.rawValue ==  MindsSDK.ProcessType.authentication.rawValue){
            endpoint = VoiceApiEndpoints.authentication(requestBody: request)
        }else {
            endpoint = VoiceApiEndpoints.enrollment(requestBody: request)
        }
        let request = endpoint.createRequest(token: token, environment: env)
        self.networkRequest.request(request) { result in
            completion(result)
        }
    }
    
    func getDsn(token: String, completion: @escaping (Result<DsnUrlResponse, NetworkError>) -> Void) {
        let endpoint: VoiceApiEndpoints = VoiceApiEndpoints.setryDsn
        let request = endpoint.createRequest(token: token, environment: env)
        self.networkRequest.request(request) { (result: Result<DsnUrlResponse, NetworkError>) in
            switch result {
            case .success(let dsnResponse):
                let newDsnResponse = DsnUrlResponse(success: dsnResponse.success, message: dsnResponse.message, data: dsnResponse.data, requestHasValidationErrors: dsnResponse.requestHasValidationErrors,
                status: dsnResponse.status, apiEnvironment: self.env.currentEnvironment
                )
                completion(.success(newDsnResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
