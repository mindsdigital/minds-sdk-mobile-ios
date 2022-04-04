//
//  MindsSDKUIMessages.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import Foundation

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public class MindsSDKUIMessages: ObservableObject {
    
    public init() {
        
    }
    
    @Published var onboardingTitle: String = ""
    @Published var hintTextTitle: String = ""
    @Published var hintTexts: [String] = []
    @Published var startRecordingButtonLabel: String = ""
    @Published var skipRecordingButtonLabel: String = ""
    @Published var instructionTextForRecording: String = ""
    @Published var recordingIndicativeText: String = ""
    @Published var confirmationMessageTitle: String = ""
    @Published var confirmationMessageBody: String = ""
    @Published var deleteMessageTitle: String = ""
    @Published var deleteMessageBody: String = ""
    @Published var confirmDeleteButtonLabel: String = ""
    @Published var dismissDeleteButtonLabel: String = ""
    @Published var sendAudioButtonLabel: String = ""
    @Published var confirmAudioButtonLabel: String = ""
    @Published var dismissAudioButtonLabel: String = ""
    @Published var genericErrorMessageTitle: String = ""
    @Published var genericErrorMessageBody: String = ""
    @Published var genericErrorButtonLabel: String = ""
    @Published var successMessageTitle: String = ""
    @Published var successMessageBody: String = ""
    @Published var successButtonLabel: String = ""
    @Published var loadingIndicativeTexts: [String] = []
    @Published var recordingItems: [RecordingItem] = []
}
