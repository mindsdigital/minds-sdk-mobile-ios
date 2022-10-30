//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 27/07/22.
//

import Foundation

public protocol MindsSDKDelegate: AnyObject {
    func onSuccess(_ response: BiometricResponse)
    func onError(_ response: BiometricResponse)
    func showMicrophonePermissionPrompt()
    func microphonePermissionNotGranted()
    func propertyListNotProvided()
}
