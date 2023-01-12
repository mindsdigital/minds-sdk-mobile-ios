//
//  File.swift
//  
//
//  Created by Divino Borges on 30/07/22.
//

import Foundation

final class BiometricServiceFactory {
    let sdkDataRepository: SDKDataRepository
    
    init(sdkDataRepository: SDKDataRepository = .shared) {
        self.sdkDataRepository = sdkDataRepository
    }

    func makeBiometricService() -> BiometricProtocol {
        return BiometricServices.init(networkRequest: NetworkManager(requestTimeout: sdkDataRepository.connectionTimeout))
    }

}
