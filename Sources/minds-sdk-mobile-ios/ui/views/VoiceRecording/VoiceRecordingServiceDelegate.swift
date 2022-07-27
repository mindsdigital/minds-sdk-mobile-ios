//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 27/07/22.
//

import Foundation

protocol VoiceRecordingServiceDelegate: AnyObject {
    var sdk: MindsSDK { get }
    var uiMessagesSdk: MindsSDKUIMessages { get }
    var recordItem: RecordingItem? { get }
    var audioRecorder: AudioRecorder { get }
    func sendAudio()

    func deleteRecorded()
    func startRecording()
    func stopRecording()
    func fetchRecording(key: String) -> URL?
}

class VoiceRecordingServiceDelegateImpl: VoiceRecordingServiceDelegate {
    var sdk: MindsSDK {
        return MindsSDK.shared
    }

    var uiMessagesSdk: MindsSDKUIMessages {
        return MindsSDKUIMessages.shared
    }

    var recordItem: RecordingItem? {
        return sdk.recordItem
    }

    var audioRecorder: AudioRecorder = AudioRecorder()

    func sendAudio() {
        guard let randomSentenceId = recordItem?.key,
              let randomSentenceIdInt = Int(randomSentenceId) else {
            return
        }

        do {
            // array of dictionaries
            var audios: [AudioFile] = []
            let recordingItem = uiMessagesSdk.recordingItem
            let src = recordingItem?.recording ?? URL(fileURLWithPath: "")
            let convertedAudioURL = ConvertAudioToOgg.convert(src: src)
            let convertedAudioData = try Data(contentsOf: convertedAudioURL)
            let encodedString = convertedAudioData.base64EncodedString()
            let audio = AudioFile(content: encodedString)
            audios.append(audio)

            let request = AudioRequest(
                action: sdk.processType.rawValue,
                cpf: sdk.cpf,
                phoneNumber: sdk.phoneNumber,
                externalCustomerID: sdk.externalId,
                audios: audios,
                liveness: RandomSentenceId(id: randomSentenceIdInt)
            )

            BiometricServices.init(networkRequest: NetworkManager(requestTimeout: sdk.connectionTimeout))
                .sendAudio(token: sdk.token, request: request) { result in
                    switch result {
                    case .success(let response):
                        if response.success {
                            print("success")
                        } else {
                            guard response.status != "invalid_length" else {
                                print("invalid_length")
                                return
                            }
                            print("error")
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        } catch {
            print("Unable to load data: \(error)")
        }
    }

    func deleteRecorded() {
        guard let selectedRecording = uiMessagesSdk.recordingItem,
              let recording = selectedRecording.recording else { return }
        audioRecorder.deleteRecording(urlsToDelete: [recording])
        uiMessagesSdk.recordingItem?.recording = nil
    }

    func stopRecording() {
        self.audioRecorder.stopRecording()
        let audio = fetchRecording(key: uiMessagesSdk.recordingItem?.id ?? "")
        uiMessagesSdk.recordingItem?.recording = audio
        audioRecorder.recordingsCount += 1
    }

    func startRecording() {
        if audioRecorder.recordingsCount < 1 {
            self.audioRecorder.startRecording(key: uiMessagesSdk.recordingItem?.id ?? "")
        } else {
            self.deleteRecorded()
            self.audioRecorder.startRecording(key: uiMessagesSdk.recordingItem?.id ?? "")
        }
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
}
