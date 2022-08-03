//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 03/08/22.
//

import SwiftUI

enum VoiceRecordErrorType {
    case invalidLength, generic

    var title: String {
        switch self {
        case .invalidLength:
            return MindsStrings.invalidLengthAlertErrorTitle()
        case .generic:
            return MindsStrings.genericErrorAlertTitle()
        }
    }

    var subtitle: String {
        switch self {
        case .invalidLength:
            return MindsStrings.invalidLengthAlertErrorSubtitle()
        case .generic:
            return MindsStrings.genericErrorAlertSubtitle()
        }
    }

    var primaryActionLabel: String {
        switch self {
        case .invalidLength:
            return ""
        case .generic:
            return MindsStrings.genericErrorAlertButtonLabel()
        }
    }

    var dismissButtonLabel: String {
        switch self {
        case .invalidLength:
            return MindsStrings.invalidLengthAlertErrorButtonLabel()
        case .generic:
            return MindsStrings.genericErrorAlertNeutralButtonLabel()
        }
    }
}

enum VoiceRecordState: Equatable {
    case initial, recording, loading, error(VoiceRecordErrorType)
    
    var isError: Binding<Bool> {
        switch self {
        case .error:
            return .constant(true)
        default:
            return .constant(false)
        }
    }

    static func == (lhs: VoiceRecordState, rhs: VoiceRecordState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial), (.recording, .recording),
             (.loading, .loading), (.error, .error):
            return true
        default:
            return false
        }
    }
}
