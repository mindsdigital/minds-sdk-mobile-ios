//
//  File.swift
//  
//
//  Created by Divino Borges on 29/07/22.
//

import Foundation

struct SendAudioToApi {

    func execute(mindsSDK: MindsSDK, biometricsService: BiometricProtocol, _ completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void) {
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
                    action: mindsSDK.processType.rawValue,
                    cpf: mindsSDK.cpf,
                    phoneNumber: mindsSDK.phoneNumber,
                    externalCustomerID: mindsSDK.externalId,
                    audios: audios,
                    liveness: mindsSDK.liveness
            )

            biometricsService.sendAudio(token: mindsSDK.token, request: request) { result in
                completion(result)
            }
        } catch {
            print("Unable to load data: \(error)")
        }
    }
}
