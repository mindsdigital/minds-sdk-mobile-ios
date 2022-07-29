//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 27/07/22.
//

import Foundation

public protocol MindsSDKDelegate: AnyObject {
    func onNetworkError(_ error: NetworkError)
    func onSuccess(_ response: BiometricResponse)
    func onServiceError(_ response: BiometricResponse)
    func onFinish()
}
