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
                    action: MindsSDK_old.shared.processType.rawValue,
                    cpf: MindsSDK_old.shared.cpf,
                    phoneNumber: MindsSDK_old.shared.phoneNumber,
                    externalCustomerID: MindsSDK_old.shared.externalId,
                    audios: audios,
                    liveness: MindsSDK_old.shared.liveness
            )

            biometricsService.sendAudio(token: MindsSDK_old.shared.token, request: request) { result in
                completion(result)
            }
        } catch {
            print("Unable to load data: \(error)")
        }
    }
}
