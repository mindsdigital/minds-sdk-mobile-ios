//
//  File.swift
//  
//
//  Created by Divino Borges on 28/07/22.
//

import Foundation

struct MindsStrings {
    static func voiceRecordingTitle() -> String {
        return NSLocalizedString("Olá! Autentique sua voz", comment: "")
    }

    static func voiceRecordingSubtitle() -> String {
        return NSLocalizedString("Segure o botão para iniciar a gravação e leia o texto abaixo", comment: "")
    }
    
    static func voiceRecordingButtonInstruction() -> String {
        return NSLocalizedString("Segure para gravar, solte para enviar", comment: "")
    }
    
    static func voiceRecordingAlertTitle() -> String {
        return NSLocalizedString("Ocorreu um erro", comment: "")
    }
    
    static func voiceRecordingAlertSubtitle() -> String {
        return NSLocalizedString("Não foi possível carregar as informações. Você deseja continuar?", comment: "")
    }
    
    static func voiceRecordingAlertButtonLabel() -> String {
        return NSLocalizedString("Tentar novamente", comment: "")
    }
    
    static func voiceRecordingAlertNeutralButtonLabel() -> String {
        return NSLocalizedString("Depois", comment: "")
    }
}
