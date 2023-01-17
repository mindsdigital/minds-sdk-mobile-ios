//
//  File.swift
//  
//
//  Created by Divino Borges on 30/07/22.
//

import Foundation

func makeBiometricService(mindsSDK: MindsSDK) -> BiometricProtocol {
    return BiometricServices.init(networkRequest: NetworkManager(requestTimeout: mindsSDK.connectionTimeout))
}
