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
            
            ClearCacheImpl().execute(url: convertedAudioURL)

            let request = AudioRequest(
                    audios: encodedString,
                    document: Document(value: sdkDataRepository.document),
                    externalId: sdkDataRepository.externalId,
                    externalCustomerID: sdkDataRepository.externalCustomerId,
                    extensionAudio: "ogg",
                    phoneNumber: sdkDataRepository.phoneNumber,
                    showDetails: sdkDataRepository.showDetails,
                    certification: sdkDataRepository.certification,
                    insertOnQuarantine: sdkDataRepository.insertOnQuarantine,
                    sourceName: "SDK_IOS",
                    liveness: Liveness(sentenceId: sdkDataRepository.liveness.id)
            )

            voiceApiService.sendAudio(token: sdkDataRepository.token, request: request) { result in
                completion(result)
            }
        } catch {
            print("Unable to load data: \(error)")
        }
    }
}
