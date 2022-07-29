//
//  LoadingView.swift
//  
//
//  Created by Liviu Bosbiciu on 05.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 15.0, *)
public struct LoadingView: View {
//    @Binding var showBiometricsFlow: Bool
    
    
    @ObservedObject var viewModel: VoiceRecordViewModel
    
    public var body: some View {
        HStack {
            LottieView(name: LottieAnimations.loadingLottieAnimation)
        }
            .frame(maxWidth: .infinity, minHeight: 80.0, maxHeight: 80.0)
            .padding()
            .onAppear {
                guard let randomSentenceId = MindsSDK.shared.recordItem?.key,
                      let randomSentenceIdInt = Int(randomSentenceId) else {
                    return
                }

                do {
                    var audios: [AudioFile] = []
               

                        let documentPath = FileManager.default.temporaryDirectory
                        let audioFilename = documentPath.appendingPathComponent("audio.wav")
                        
                        let convertedAudioURL = ConvertAudioToOgg.convert(src: audioFilename)
                        
                        let convertedAudioData = try Data(contentsOf: convertedAudioURL)
                        
                        let encodedString = convertedAudioData.base64EncodedString()
                        
                        let audio = AudioFile(
                            content: encodedString
                        )
                        audios.append(audio)
                    

                    let request = AudioRequest(
                        action: MindsSDK.shared.processType.rawValue,
                        cpf: MindsSDK.shared.cpf,
                        phoneNumber: MindsSDK.shared.phoneNumber,
                        externalCustomerID: MindsSDK.shared.externalId,
                        audios: audios,
                        liveness: RandomSentenceId(id: randomSentenceIdInt)
                    )
                    
                    BiometricServices.init(networkRequest: NetworkManager(requestTimeout: MindsSDK.shared.connectionTimeout))
                        .sendAudio(token: MindsSDK.shared.token, request: request) { result in
//                            self.serviceResult = result
                            switch result {
                            case .success(let response):
                                if response.success {
//                                    showBiometricsFlow = false
                                    MindsSDK.shared.onBiometricsReceive?(response)
                                } else {
                                    viewModel.state = .error
                                    viewModel.biometricsResponse = response
//                                    showLoadingView = false
//                                    hasError = true
//                                    guard response.status != "invalid_length" else {
////                                        self.invalidLength = true
////                                        self.currentScreen = .error
//                                        return
//                                    }

//                                    self.invalidLength = false
//                                    currentScreen = .error
                                }
                            case .failure(_):
//                                showLoadingView = false
//                                hasError = true
//                                biometricsResponse = nil
                                viewModel.state = .error
//                                currentScreen = .error
                            }
                        }
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
    }
}
