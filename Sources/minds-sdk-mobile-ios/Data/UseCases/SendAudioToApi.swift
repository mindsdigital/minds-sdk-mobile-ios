//
//  File.swift
//  
//
//  Created by Divino Borges on 29/07/22.
//

import Foundation

struct SendAudioToApi {
    @available(iOS 13.0, *)
    func execute(biometricsService: BiometricProtocol, _ completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void) {
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
                    liveness: MindsSDK.shared.liveness
            )

            biometricsService.sendAudio(token: MindsSDK.shared.token, request: request) { result in
                completion(result)
            }
        } catch {
            print("Unable to load data: \(error)")
        }
    }
}
