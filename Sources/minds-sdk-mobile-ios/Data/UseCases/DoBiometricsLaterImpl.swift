//
//  File.swift
//  
//
//  Created by Divino Borges on 25/07/22.
//

import Foundation

@available(iOS 14.0, *)
struct DoBiometricsLaterImpl : DoBiometricsLater {
    func execute(biometricResponse: BiometricResponse) {
        var response = biometricResponse
        response.status = "do_biometric_later"
        
        DispatchQueue.main.async {
            MindsSDK.shared.onBiometricsReceive?(response)
        }
    }
}