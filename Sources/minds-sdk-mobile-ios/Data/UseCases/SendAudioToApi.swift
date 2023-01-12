//
//  File.swift
//  
//
//  Created by Divino Borges on 29/07/22.
//

import Foundation

struct SendAudioToApi {

    func execute(sdkDataRepository: SDKDataRepository = .shared,
                 biometricsService: BiometricProtocol, _ completion: @escaping (Result<BiometricResponse, NetworkError>) -> Void) {
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
                    action: sdkDataRepository.processType.rawValue,
                    cpf: sdkDataRepository.cpf,
                    phoneNumber: sdkDataRepository.phoneNumber,
                    externalCustomerID: sdkDataRepository.externalId,
                    audios: audios,
                    liveness: sdkDataRepository.liveness
            )

            biometricsService.sendAudio(token: sdkDataRepository.token, request: request) { result in
                completion(result)
            }
        } catch {
            print("Unable to load data: \(error)")
        }
    }
}
