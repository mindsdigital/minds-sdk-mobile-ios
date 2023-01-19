//
//  File.swift
//  
//
//  Created by Divino Borges on 29/07/22.
//

import Foundation

struct SendAudioToApi {
    func execute(voiceApiService: VoiceApiProtocol, _ completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void) {
        do {
            let documentPath = FileManager.default.temporaryDirectory

            let audioFilename = documentPath.appendingPathComponent("audio.wav")

            let convertedAudioURL = ConvertAudioToOgg.convert(src: audioFilename)

            let convertedAudioData = try Data(contentsOf: convertedAudioURL)

            let encodedString = convertedAudioData.base64EncodedString()

         

            let request = AudioRequest(
                    audios: encodedString,
                    cpf: MindsSDK.shared.cpf,
                    externalId: MindsSDK.shared.externalId,
                    externalCustomerID: MindsSDK.shared.externalCustomerId,
                    extensionAudio: "ogg",
                    phoneNumber: MindsSDK.shared.phoneNumber,
                    showDetails: MindsSDK.shared.showDetails,
                    sourceName: "SDK_IOS"
            )

            voiceApiService.sendAudio(token: MindsSDK.shared.token, request: request) { result in
                completion(result)
            }
        } catch {
            print("Unable to load data: \(error)")
        }
    }
}
