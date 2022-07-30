//
//  File.swift
//  
//
//  Created by Divino Borges on 30/07/22.
//

import Foundation

func makeBiometricService() -> BiometricProtocol {
    return BiometricServices.init(networkRequest: NetworkManager(requestTimeout: MindsSDK.shared.connectionTimeout))
}
