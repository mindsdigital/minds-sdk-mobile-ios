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
            return MindsStrings.invalidLengthAlertErrorTitle()
        }
    }

    var subtitle: String {
        switch self {
        case .invalidLength:
            return MindsStrings.invalidLengthAlertErrorSubtitle()
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
            return MindsStrings.invalidLengthAlertErrorButtonLabel()
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
