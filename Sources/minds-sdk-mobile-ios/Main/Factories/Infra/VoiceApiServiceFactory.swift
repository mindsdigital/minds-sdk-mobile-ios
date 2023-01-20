//
//  File.swift
//  
//
//  Created by Wennys on 18/01/23.
//

import Foundation

func makeVoiceApiService() -> VoiceApiProtocol {
    return VoiceApiServices.init(networkRequest: NetworkManager(requestTimeout: MindsSDK.shared.connectionTimeout))
}
