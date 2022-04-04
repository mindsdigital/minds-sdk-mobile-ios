//
//  MindsSDKUIMessages.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import Foundation

@available(macOS 11, *)
@available(iOS 13.0, *)
public class MindsSDKUIMessages: ObservableObject {
    static public let shared = MindsSDKUIMessages()
    
    public init() {
        
    }
    
    @Published public var onboardingTitle: String = ""
    @Published public var hintTextTitle: String = ""
    @Published public var hintTexts: [String] = []
    @Published public var startRecordingButtonLabel: String = ""
    @Published public var skipRecordingButtonLabel: String = ""
    @Published public var instructionTextForRecording: String = ""
    @Published public var recordingIndicativeText: String = ""
    @Published public var confirmationMessageTitle: String = ""
    @Published public var confirmationMessageBody: String = ""
    @Published public var deleteMessageTitle: String = ""
    @Published public var deleteMessageBody: String = ""
    @Published public var confirmDeleteButtonLabel: String = ""
    @Published public var dismissDeleteButtonLabel: String = ""
    @Published public var sendAudioButtonLabel: String = ""
    @Published public var confirmAudioButtonLabel: String = ""
    @Published public var dismissAudioButtonLabel: String = ""
    @Published public var genericErrorMessageTitle: String = ""
    @Published public var genericErrorMessageBody: String = ""
    @Published public var genericErrorButtonLabel: String = ""
    @Published public var successMessageTitle: String = ""
    @Published public var successMessageBody: String = ""
    @Published public var successButtonLabel: String = ""
    @Published public var loadingIndicativeTexts: [String] = []
    @Published public var recordingItems: [RecordingItem] = []
}
