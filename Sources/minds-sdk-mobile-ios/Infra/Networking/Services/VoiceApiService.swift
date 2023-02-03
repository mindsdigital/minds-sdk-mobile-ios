//
//  File.swift
//  
//
//  Created by Wennys on 18/01/23.
//


protocol VoiceApiProtocol {
    func sendAudio(token: String, request: AudioRequest, completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void)
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
}
