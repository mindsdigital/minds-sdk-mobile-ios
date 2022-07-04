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
                ErrorView(action: {
                    numbersOfRetry += 1
                    if invalidLength {
                        if let nextQuestion = AdditionalValidationGenerator.shared.getNextQuestion() {
                            uiMessagesSdk.recordingItems.append(RecordingItem(key: "Repita a frase", value: nextQuestion))
                            hideBackButton = false
                            currentScreen = Screen.main
                        } else {
                            invalidLength = false
                        }
                        
                    } else {
                        sendAudio()
                    }
                }, tryAgain: {
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
                            resetAdditionalValidation()
                        } else {
                            resetAdditionalValidation()
                        }
                    }
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
    }
    
    private var audioScrollView: some View {
        ScrollView {
            ScrollViewReader { reader in
                VStack(alignment: .leading) {
                    ForEach(0..<min(uiMessagesSdk.recordingItems.count, audioRecorder.recordingsCount + 1), id: \.self) { i in
                        Text(uiMessagesSdk.recordingItems[i].key)
                            .foregroundColor(i != min(uiMessagesSdk.recordingItems.count, audioRecorder.recordingsCount + 1) - 1 ? Color.gray : uiConfigSdk.hexVariant100)
                            .font(uiConfigSdk.fontFamily.isEmpty ?
                                .headline : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .headline)
                            )
                        Text(uiMessagesSdk.recordingItems[i].value)
                            .foregroundColor(i != min(uiMessagesSdk.recordingItems.count, audioRecorder.recordingsCount + 1) - 1 ? Color.gray : uiConfigSdk.hexVariant300)
                            .font(uiConfigSdk.fontFamily.isEmpty ?
                                .title2 : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .title2)
                            )
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
            Divider()
            VStack {
                if (audioRecorder.recordingsCount == uiMessagesSdk.recordingItems.count) {
                    Button(action: {
                        sendAudio()
                    }) {
                        Text(uiMessagesSdk.sendAudioButtonLabel)
                            .font(uiConfigSdk.fontFamily.isEmpty ?
                                .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                            )
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .fillButtonStyle(backgroundColor: uiConfigSdk.hexVariant400)
                } else {
                    
                    Text(audioRecorder.recording ? uiMessagesSdk.recordingIndicativeText : uiMessagesSdk.instructionTextForRecording)
                        .foregroundColor(uiConfigSdk.textColor)
                        .font(uiConfigSdk.fontFamily.isEmpty ?
                            .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                        )
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
        do {
            var rate = "8K"
            if sdk.linearPCMBitDepthKey != 8 {
                rate = "16K"
            }
            // array of dictionaries
            var audios: [AudioFile] = []
            for recordingItem in uiMessagesSdk.recordingItems {
                let data = try Data(contentsOf: recordingItem.recording!)
                let encodedString = data.base64EncodedString()
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
                audios: audios
            )
            
            hideBackButton = true
            currentScreen = Screen.loading
            
            BiometricServices.init(networkRequest: NetworkManager())
                .sendAudio(token: sdk.token, request: request) { result in
                    self.serviceResult = result
                    switch result {
                    case .success(let response):
                        if response.success {
                            self.invalidLength = false
                            resetAdditionalValidation()
                            
                            guard uiConfigSdk.showThankYouScreen else {
                                hideBackButton = false
                                voiceRecordingFlowActive = false
                                return
                            }
                            currentScreen = .thankYou
                        } else {
                            guard response.status != "invalid_length" else {
                                self.invalidLength = true
                                uiMessagesSdk.genericErrorMessageBody = invalidLength ? "Duração de audio inválida" : uiMessagesSdk.genericErrorMessageBody
                                currentScreen = .error
                                return
                            }
                            
                            self.invalidLength = false
                            resetAdditionalValidation()
                            currentScreen = .error
                        }
                    case .failure(let error):
                        print(error)
                        resetAdditionalValidation()
                        currentScreen = .error
                    }
                    uiMessagesSdk.genericErrorMessageBody = invalidLength ? "Duração de audio inválida" : uiMessagesSdk.genericErrorMessageBody
                }
        } catch {
            print("Unable to load data: \(error)")
            resetAdditionalValidation()
        }
    }

    private func resetAdditionalValidation() {
        AdditionalValidationGenerator.shared.reset()
        uiMessagesSdk.recordingItems.removeAll { item in
            item.key == "Repita a frase"
        }
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

    private func appendNumberOfRetries(_ result: Result<BiometricResponse, NetworkError>) -> Result<BiometricResponse, NetworkError> {
        switch result {
        case .success(let response):
            let responseStatus = self.numbersOfRetry > 0 ? "do_biometrics_later" : response.status
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
                                                    numberOfRetries: self.numbersOfRetry)
            return .success(successResponse)
        case .failure(let error):
            return .failure(error)
        }
    }
}


struct AdditionalValidationGenerator {
    static var shared = AdditionalValidationGenerator()
    
    private var currentIndex: Int = 0
    
    let additionalValidation = [
        "Aqui, a minha voz é a minha senha",
        "A minha conta é protegida pela minha voz",
        "Minha identidade é representada pela minha voz",
        "Minha proteção é garantida pela minha voz",
        "A minha voz é exclusiva e irreproduzível",
        "A minha voz me traz segurança e eu quero autenticá-la"
    ]
    
    mutating func getNextQuestion() -> String? {
        if currentIndex < additionalValidation.count {
            let referenceString = additionalValidation[currentIndex]
            currentIndex += 1
            return referenceString
        }
        
        return nil
    }
    
    mutating func reset() {
        currentIndex = 0
    }
}

@available(iOS 14.0, *)
struct VoiceRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        let uiMessagesSdk = MindsSDKUIMessages.shared
        uiMessagesSdk.genericErrorMessageTitle = "Algo deu errado"
        uiMessagesSdk.genericErrorMessageBody = "Ocorreu um erro de conexão entre nossos servidores. Por favor, tente novamente."
        uiMessagesSdk.genericErrorButtonLabel = "Tentar novamente"
        return ErrorView(action: {
            
        })
    }
}
