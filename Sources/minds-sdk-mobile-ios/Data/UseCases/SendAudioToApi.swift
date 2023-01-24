//
//  File.swift
//  
//
//  Created by Divino Borges on 29/07/22.
//

import Foundation

struct SendAudioToApi {
    func execute(sdkDataRepository: SDKDataRepository = .shared,
                 voiceApiService: VoiceApiProtocol,
                 _ completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void) {
        do {
            let documentPath = FileManager.default.temporaryDirectory

            let audioFilename = documentPath.appendingPathComponent("audio.wav")

            let convertedAudioURL = ConvertAudioToOgg.convert(src: audioFilename)

            let convertedAudioData = try Data(contentsOf: convertedAudioURL)

            let encodedString = convertedAudioData.base64EncodedString()

         

            let request = AudioRequest(
                    audios: encodedString,
                    cpf: sdkDataRepository.cpf,
                    externalId: sdkDataRepository.externalId,
                    externalCustomerID: sdkDataRepository.externalCustomerId,
                    extensionAudio: "ogg",
                    phoneNumber: sdkDataRepository.phoneNumber,
                    showDetails: sdkDataRepository.showDetails,
                    sourceName: "SDK_IOS"
            )

            voiceApiService.sendAudio(token: sdkDataRepository.token, request: request) { result in
                completion(result)
            }
        } catch {
            print("Unable to load data: \(error)")
        }
    }
}
