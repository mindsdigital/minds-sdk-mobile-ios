//
//  File.swift
//  
//
//  Created by Divino Borges on 28/07/22.
//

import Foundation
import SwiftUI

struct MindsSDKConfigs {
    static var config: [String: Any]?

    static func voiceRecordingTitle() -> String {
        return getProperty(name: "VoiceRecordingTitle")
    }

    static func voiceRecordingSubtitle() -> String {
        return getProperty(name: "VoiceRecordingSubtitle")
    }
    
    static func voiceRecordingButtonInstruction() -> String {
        return getProperty(name: "VoiceRecordingButtonInstruction")
    }
    
    static func genericErrorAlertTitle() -> String {
        return getProperty(name: "GenericErrorAlertTitle")
    }
    
    static func genericErrorAlertSubtitle() -> String {
        return getProperty(name: "GenericErrorAlertSubtitle")
    }
    
    static func genericErrorAlertButtonLabel() -> String {
        return getProperty(name: "GenericErrorAlertButtonLabel")
    }
    
    static func genericErrorAlertNeutralButtonLabel() -> String {
        return getProperty(name: "GenericErrorAlertNeutralButtonLabel")
    }

    static func invalidLengthAlertErrorTitle() -> String {
        return getProperty(name: "InvalidLengthAlertErrorTitle")
    }
    
    static func invalidLengthAlertErrorSubtitle() -> String {
        return getProperty(name: "InvalidLengthAlertErrorSubtitle")
    }
    
    static func invalidLengthAlertErrorButtonLabel() -> String {
        return getProperty(name: "InvalidLengthAlertErrorButtonLabel")
    }

    static func voiceRecordTitleColor() -> Color {
        let colorCode: String = getProperty(name: "VoiceRecordingTitleColor")
        return .init(hex: colorCode)
    }

    static func voiceRecordSubtitleColor() -> Color {
        let colorCode: String = getProperty(name: "VoiceRecordingSubtitleColor")
        return .init(hex: colorCode)
    }

    static func voiceRecordMainTextColor() -> Color {
        let colorCode: String = getProperty(name: "VoiceRecordingMainTextColor")
        return .init(hex: colorCode)
    }

    static private func getProperty(name infoName: String) -> String {
        return config?[infoName] as? String ?? ""
    }
}
