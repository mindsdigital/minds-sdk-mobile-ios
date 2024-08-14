//
//  File.swift
//  
//
//  Created by Divino Borges on 28/07/22.
//

import Foundation
import SwiftUI

struct MindsSDKConfigs {

    var config: [String: Any]?
    static var shared: MindsSDKConfigs = MindsSDKConfigs()
    
    private init() {
        loadMindSDKPlist()
    }

    private func loadMindSDKPlist() {
        if let infoPlistPath = Bundle.main.url(forResource: "MindsSDK",
                                               withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)

                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData,
                                                                         options: [],
                                                                         format: nil) as? [String: Any] {
                    DispatchQueue.main.async {
                        MindsSDKConfigs.shared.config = dict
                    }
                }
            } catch {
                
            }
        }
    }

    func voiceRecordingAuthenticationTitle() -> String {
        return getProperty(name: "VoiceRecordingAuthenticationTitle")
    }
    
    func voiceRecordingEnrollmentTitle() -> String {
        return getProperty(name: "VoiceRecordingEnrollmentTitle")
    }

    func voiceRecordingSubtitle() -> String {
        return getProperty(name: "VoiceRecordingSubtitle")
    }
    
    func voiceRecordingButtonInstruction() -> String {
        return getProperty(name: "VoiceRecordingButtonInstruction")
    }
    
    func genericErrorAlertTitle() -> String {
        return getProperty(name: "GenericErrorAlertTitle")
    }
    
    func genericErrorAlertSubtitle() -> String {
        return getProperty(name: "GenericErrorAlertSubtitle")
    }
    
    func genericErrorAlertButtonLabel() -> String {
        return getProperty(name: "GenericErrorAlertButtonLabel")
    }
    
    func genericErrorAlertNeutralButtonLabel() -> String {
        return getProperty(name: "GenericErrorAlertNeutralButtonLabel")
    }

    func invalidLengthAlertErrorTitle() -> String {
        return getProperty(name: "InvalidLengthAlertErrorTitle")
    }
    
    func invalidLengthAlertErrorSubtitle() -> String {
        return getProperty(name: "InvalidLengthAlertErrorSubtitle")
    }
    
    func invalidLengthAlertErrorButtonLabel() -> String {
        return getProperty(name: "InvalidLengthAlertErrorButtonLabel")
    }

    func voiceRecordTitleColor() -> UIColor {
        let colorCode: String = getProperty(name: "VoiceRecordingTitleColor")
        return .init(hex: colorCode)
    }

    func voiceRecordSubtitleColor() -> UIColor {
        let colorCode: String = getProperty(name: "VoiceRecordingSubtitleColor")
        return .init(hex: colorCode)
    }

    func voiceRecordMainTextColor() -> UIColor {
        let colorCode: String = getProperty(name: "VoiceRecordingMainTextColor")
        return .init(hex: colorCode)
    }
    
    func loadingLootieAnimationColor() -> String {
        let colorCode: String = getProperty(name: "LoadingLootieAnimationColor")
        return colorCode
    }
    
    func voiceRecordingLootieAnimationColor() -> String {
        let colorCode: String = getProperty(name: "VoiceRecordingLootieAnimationColor")
        return colorCode
    }
    
    func voiceRecordingButtonColor() -> UIColor {
        let colorCode: String = getProperty(name: "VoiceRecordingButtonColor")
        return .init(hex: colorCode)
    }

    private func getProperty(name infoName: String) -> String {
        guard let property = config?[infoName] as? String else {
            return DefaultMindsSDKConfigs.config[infoName] ?? ""
        }
        return property
    }

}

fileprivate struct DefaultMindsSDKConfigs {

    static var config: [String: String] = [
        "VoiceRecordingAuthenticationTitle": "Olá! Autentique sua voz",
        "VoiceRecordingEnrollmentTitle": "Olá! Cadastre sua voz",
        "VoiceRecordingSubtitle": "Segure o botão para iniciar a gravação \ne leia o texto abaixo",
        "VoiceRecordingButtonInstruction": "Segure para gravar, solte para enviar",
        "GenericErrorAlertTitle": "Ocorreu um erro",
        "GenericErrorAlertSubtitle": "Não foi possível carregar as informações. Você deseja continuar?",
        "GenericErrorAlertButtonLabel": "Tentar novamente",
        "GenericErrorAlertNeutralButtonLabel": "Depois",
        "InvalidLengthAlertErrorTitle": "Duração inválida",
        "InvalidLengthAlertErrorSubtitle": "O áudio gravado precisa ter pelo menos 5 segundos",
        "InvalidLengthAlertErrorButtonLabel": "Tentar novamente",
        "VoiceRecordingTitleColor": "#252525",
        "VoiceRecordingSubtitleColor": "#5F5F5F",
        "VoiceRecordingMainTextColor": "#252525",
        "LoadingLootieAnimationColor": "#0055FF",
        "VoiceRecordingLootieAnimationColor": "#0055FF",
        "VoiceRecordingButtonColor": "#0055FF"
    ]

}
