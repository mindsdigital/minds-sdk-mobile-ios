//
//  File.swift
//  
//
//  Created by Divino Borges on 25/07/22.
//

import Foundation

struct DoBiometricsLaterImpl: DoBiometricsLater {
    func execute(biometricResponse: BiometricResponse, delegate: MindsSDKDelegate?) {
        delegate?.onSuccess(nil)
    }
}
