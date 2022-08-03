//
//  File.swift
//  
//
//  Created by Divino Borges on 25/07/22.
//

import Foundation

protocol DoBiometricsLater {
    func execute(biometricResponse: BiometricResponse, delegate: MindsSDKDelegate?) -> Void
}
