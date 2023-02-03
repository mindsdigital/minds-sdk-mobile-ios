//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 03/08/22.
//

import SwiftUI

enum VoiceRecordErrorType {

    case invalidLength

    var title: String {
        switch self {
        case .invalidLength:
            return MindsSDKConfigs.shared.invalidLengthAlertErrorTitle()
        }
    }

    var subtitle: String {
        switch self {
        case .invalidLength:
            return MindsSDKConfigs.shared.invalidLengthAlertErrorSubtitle()
        }
    }

    var primaryActionLabel: String {
        switch self {
        case .invalidLength:
            return ""
        }
    }

    var dismissButtonLabel: String {
        switch self {
        case .invalidLength:
            return MindsSDKConfigs.shared.invalidLengthAlertErrorButtonLabel()
        }
    }
}
