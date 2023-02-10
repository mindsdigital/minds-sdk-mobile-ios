//
//  File.swift
//  
//
//  Created by Divino Borges on 25/07/22.
//

import Foundation

struct DoBiometricsLaterImpl: DoBiometricsLater {
    func execute(biometricResponse: BiometricResponse, delegate: MindsSDKDelegate?) {
        var response = biometricResponse
        response.success = false
        response.error?.code = "do_biometric_later"
        response.error?.description = "O usuário optou por tentar realizar o processo de biometria mais tarde"
        delegate?.onError(response)
    }
}
