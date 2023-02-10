//
//  File.swift
//  
//
//  Created by Wennys on 18/01/23.
//

import Foundation

final class VoiceApiServiceFactory {

    func makeVoiceApiService() -> VoiceApiProtocol {
        return VoiceApiServices.init(networkRequest: NetworkManager(requestTimeout: SDKDataRepository.shared.connectionTimeout))
    }

}
