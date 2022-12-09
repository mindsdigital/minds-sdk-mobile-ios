//
//  File.swift
//  
//
//  Created by Divino Borges on 30/07/22.
//

import Foundation

@available(iOS 13.0, *)
func makeBiometricService() -> BiometricProtocol {
    return BiometricServices.init(networkRequest: NetworkManager(requestTimeout: MindsSDK_iOS13.shared.connectionTimeout))
}
