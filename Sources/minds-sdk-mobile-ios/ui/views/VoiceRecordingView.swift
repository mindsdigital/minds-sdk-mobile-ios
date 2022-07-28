//
//  VoiceRecordingView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI
import Alamofire
import Combine

enum Screen {
    case main
    case loading
    case error
    case thankYou
}

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct VoiceRecordingView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    @ObservedObject var sdk = MindsSDK.shared
    @State var showActionSheet: Bool = false
    @State var selectedRecording: RecordingItem? = nil
    @State var selectedRecordingIndex: Int = 0
    @State var hideBackButton: Bool = false
    @State var invalidLength: Bool = false
    @State var currentScreen: Screen = Screen.main
    @StateObject var audioRecorder: AudioRecorder = AudioRecorder()
    @Binding var voiceRecordingFlowActive: Bool
    @State var doBiometricsLater: Bool = false
    @State var numbersOfRetry: Int = 0
    @State var serviceResult: Result<BiometricResponse, NetworkError>?

    public init(voiceRecordingFlowActive: Binding<Bool>) {
        self._voiceRecordingFlowActive = voiceRecordingFlowActive
    }
    
    func fetchRecording(key: String) -> URL? {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.temporaryDirectory
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            if (audio.lastPathComponent.starts(with: key)) {
                return audio
            }
        }
        return nil
    }
    
    public var body: some View {
        VStack {
            if currentScreen == Screen.main {
                VStack(alignment: .leading) {
                    
                    audioScrollView
                    // Bottom Recording View
                    bottomRecordingView
                }
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text(uiMessagesSdk.deleteMessageTitle),
                                message: Text(uiMessagesSdk.deleteMessageBody),
                                buttons: [
                                    .cancel(
                                        Text(uiMessagesSdk.dismissDeleteButtonLabel)),
                                    .destructive(
                                        Text(uiMessagesSdk.confirmDeleteButtonLabel),
                                        action: {
                                            if (selectedRecording != nil && selectedRecording!.recording != nil) {
                                                audioRecorder.deleteRecording(urlsToDelete: [
                                                    selectedRecording!.recording!
                                                ])
                                                uiMessagesSdk.recordingItems[selectedRecordingIndex].recording = nil
                                            }
                                        }
                                    )
                                ]
                    )
                }
            } else if (currentScreen == Screen.loading) {
                LoadingView()
            } else if (currentScreen == Screen.error) {
                ErrorView(invalidLength: invalidLength, action: {
                    numbersOfRetry += 1
                    if invalidLength {
                        deleteRecorded()
                        currentScreen = .main
                    } else {
                        sendAudio()
                    }
                }, tryAgain: {
                    doBiometricsLater = true
                    hideBackButton = false
                    voiceRecordingFlowActive = false
                    sendResultToHostApplication()
                })
            } else if (currentScreen == Screen.thankYou) {
                SuccessView(action: {
                    hideBackButton = false
                    voiceRecordingFlowActive = false
                    sendResultToHostApplication()
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Group {
            if !hideBackButton {
                Button(action: {
                    if audioRecorder.recordingsCount > 1 {
                        for item in uiMessagesSdk.recordingItems.reversed() {
                            if item.recording != nil,
                               let index = uiMessagesSdk.recordingItems.firstIndex(of: item) {
                                selectedRecording = item
                                selectedRecordingIndex = index
                                self.showActionSheet = true
                                break
                            }
                        }
                    } else {
                        if let item = uiMessagesSdk.recordingItems.first, item.recording != nil {
                            selectedRecording = item
                            selectedRecordingIndex = 0
                            self.showActionSheet = true
                        }
                    }
                    self.voiceRecordingFlowActive = false
                }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                    }
                })
            } else {
                EmptyView()
            }
        })
        .preferredColorScheme(.light)
        .environment(\.colorScheme, .light)
        .disableRotation()
    }
    
    private var audioScrollView: some View {
        ScrollView {
            ScrollViewReader { reader in
                VStack(alignment: .leading) {
                    ForEach(0..<min(uiMessagesSdk.recordingItems.count, audioRecorder.recordingsCount + 1), id: \.self) { i in
                        Text(uiMessagesSdk.recordingItems[i].key)
                            .foregroundColor(i != min(uiMessagesSdk.recordingItems.count, audioRecorder.recordingsCount + 1) - 1 ? Color.gray : uiConfigSdk.hexVariant100)
                            .font(customFont(defaultFont: .headline, defaultStyle: .headline))
                        Text(uiMessagesSdk.recordingItems[i].value)
                            .foregroundColor(i != min(uiMessagesSdk.recordingItems.count, audioRecorder.recordingsCount + 1) - 1 ? Color.gray : uiConfigSdk.hexVariant300)
                            .font(customFont(defaultFont: .title2, defaultStyle: .title2))
                            .id(uiMessagesSdk.recordingItems[i].id)
                        if (uiMessagesSdk.recordingItems[i].recording != nil) {
                            RecordingItemView(audioURL: uiMessagesSdk.recordingItems[i].recording!,
                                              displayRemoveButton: i == audioRecorder.recordingsCount - 1,
                                              onDeleteAction: {
                                selectedRecording = uiMessagesSdk.recordingItems[i]
                                selectedRecordingIndex = i
                                self.showActionSheet = true
                            })
                            .id(uiMessagesSdk.recordingItems[i].id + "recording")
                        }
                    }
                }
                .padding(.horizontal)
                .id("main")
                .onChange(of: audioRecorder.recordingsCount) { count in
                    if (audioRecorder.recordingsCount < uiMessagesSdk.recordingItems.count && uiMessagesSdk.recordingItems[audioRecorder.recordingsCount].recording != nil) {
                        reader.scrollTo(uiMessagesSdk.recordingItems[audioRecorder.recordingsCount].id + "recording")
                    } else {
                        reader.scrollTo(uiMessagesSdk.recordingItems[min(uiMessagesSdk.recordingItems.count - 1, count)].id)
                    }
                }
                
            }
        }
    }
    
    private var bottomRecordingView: some View {
        VStack{
            LottieView(name: LottieAnimations.audioRecordingLottieAnimation)
            Text(MindsStrings.voiceRecordingButtonInstruction())
            Divider()
            VStack {
                if (audioRecorder.recordingsCount == uiMessagesSdk.recordingItems.count) {
                    Button(action: {
                        sendAudio()
                    }) {
                        Text(uiMessagesSdk.audioSendButtonLabel)
                            .font(uiConfigSdk.getFontFamily().isEmpty ?
                                .body : .custom(uiConfigSdk.getFontFamily(), size: uiConfigSdk.getTypographyScale(), relativeTo: .body)
                            )
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .fillButtonStyle(backgroundColor: uiConfigSdk.hexVariant400)
                } else {
                    
                    Text(audioRecorder.recording ? uiMessagesSdk.recordingIndicativeText : uiMessagesSdk.instructionTextForRecording)
                        .foregroundColor(uiConfigSdk.textColor)
                        .font(customFont(defaultFont: .body, defaultStyle: .body))
                        .padding(.top, 5)
                    RecordingButton(isRecording: audioRecorder.recording,
                                    background: uiConfigSdk.hexVariant400,
                                    recordingButtonHandler: self.recordingButtonHandler,
                                    stopButtonHandler: self.stopButtonHandler)
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }

    private func deleteRecorded() {
        guard let selectedRecording = uiMessagesSdk.recordingItems.first,
              let recording = selectedRecording.recording else { return }
        audioRecorder.deleteRecording(urlsToDelete: [recording])
        uiMessagesSdk.recordingItems[selectedRecordingIndex].recording = nil
    }

    private func recordingButtonHandler() {
        self.audioRecorder.stopRecording()
        let audio = fetchRecording(key: uiMessagesSdk.recordingItems[audioRecorder.recordingsCount].id)
        uiMessagesSdk.recordingItems[audioRecorder.recordingsCount].recording = audio
        audioRecorder.recordingsCount += 1
    }

    private func stopButtonHandler() {
        if (audioRecorder.recordingsCount < uiMessagesSdk.recordingItems.count) {
            self.audioRecorder.startRecording(key: uiMessagesSdk.recordingItems[audioRecorder.recordingsCount].id)
        }
    }

    private func sendAudio() {
        guard let randomSentenceId = sdk.recordItem?.key,
              let randomSentenceIdInt = Int(randomSentenceId) else {
            return
        }

        do {

            // array of dictionaries
            var audios: [AudioFile] = []
            for recordingItem in uiMessagesSdk.recordingItems {

                let src = recordingItem.recording!
                
                let convertedAudioURL = ConvertAudioToOgg.convert(src: src)
                
                let convertedAudioData = try Data(contentsOf: convertedAudioURL)
                
                let encodedString = convertedAudioData.base64EncodedString()
                
                let audio = AudioFile(
                    content: encodedString
                )
                audios.append(audio)
            }

            let request = AudioRequest(
                action: sdk.processType.rawValue,
                cpf: sdk.cpf,
                phoneNumber: sdk.phoneNumber,
                externalCustomerID: sdk.externalId,
                audios: audios,
                liveness: RandomSentenceId(id: randomSentenceIdInt)
            )
            
            hideBackButton = true
            currentScreen = Screen.loading
            
            BiometricServices.init(networkRequest: NetworkManager(requestTimeout: sdk.connectionTimeout))
                .sendAudio(token: sdk.token, request: request) { result in
                    self.serviceResult = result
                    switch result {
                    case .success(let response):
                        if response.success {
                            self.invalidLength = false
                            guard uiConfigSdk.showThankYouScreen else {
                                hideBackButton = false
                                voiceRecordingFlowActive = false
                                self.sendResultToHostApplication()
                                return
                            }
                            currentScreen = .thankYou
                        } else {
                            guard response.status != "invalid_length" else {
                                self.invalidLength = true
                                self.currentScreen = .error
                                return
                            }

                            self.invalidLength = false
                            currentScreen = .error
                        }
                    case .failure(let error):
                        print(error)
                        currentScreen = .error
                    }
                }
        } catch {
            print("Unable to load data: \(error)")
        }
    }

    private func customFont(defaultFont: Font, defaultStyle: Font.TextStyle) -> Font {
        let customFont: Font = .custom(uiConfigSdk.getFontFamily(), size: uiConfigSdk.getTypographyScale(), relativeTo: defaultStyle)
        return uiConfigSdk.getFontFamily().isEmpty ? defaultFont : customFont
    }
}

@available(iOS 14.0, *)
extension VoiceRecordingView {
    func sendResultToHostApplication() {
        guard let result = self.serviceResult else {
            return
        }

        DispatchQueue.main.async {
            self.sdk.onBiometricsReceive?(self.appendNumberOfRetries(result))
        }
    }

    private func appendNumberOfRetries(_ result: Result<BiometricResponse, NetworkError>) -> BiometricResponse {
        var biometricResponse: BiometricResponse
        switch result {
        case .success(let response):
            let responseStatus = self.doBiometricsLater ? "do_biometrics_later" : response.status
            let successResponse = BiometricResponse(id: response.id,
                                                    cpf: response.cpf,
                                                    verificationID: response.verificationID,
                                                    action: response.action,
                                                    externalId: response.externalId,
                                                    status: responseStatus,
                                                    createdAt: response.createdAt,
                                                    success: response.success,
                                                    whitelisted: response.whitelisted,
                                                    fraudRisk: response.fraudRisk,
                                                    enrollmentExternalId: response.enrollmentExternalId,
                                                    matchPrediction: response.matchPrediction,
                                                    confidence: response.confidence,
                                                    message: response.message,
                                                    numberOfRetries: self.numbersOfRetry,
                                                    flag: response.flag,
                                                    liveness: response.liveness)
            biometricResponse = successResponse
        case .failure(let error):
            let failureResponse = BiometricResponse(status: error.message,
                                                    success: false,
                                                    message: error.localizedDescription)
            biometricResponse = failureResponse
        }
        return biometricResponse
    }
}
