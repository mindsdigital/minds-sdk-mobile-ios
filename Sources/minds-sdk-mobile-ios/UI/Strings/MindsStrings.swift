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
    
    static func genericErrorAlertTitle() -> String {
        return NSLocalizedString("Ocorreu um erro", comment: "")
    }
    
    static func genericErrorAlertSubtitle() -> String {
        return NSLocalizedString("Não foi possível carregar as informações. Você deseja continuar?", comment: "")
    }
    
    static func genericErrorAlertButtonLabel() -> String {
        return NSLocalizedString("Tentar novamente", comment: "")
    }
    
    static func genericErrorAlertNeutralButtonLabel() -> String {
        return NSLocalizedString("Depois", comment: "")
    }

    static func invalidLengthAlertErrorTitle() -> String {
        return NSLocalizedString("Duração inválida", comment: "")
    }
    
    static func invalidLengthAlertErrorSubtitle() -> String {
        return NSLocalizedString("O áudio gravado precisa ter pelo menos 5 segundos", comment: "")
    }
    
    static func invalidLengthAlertErrorButtonLabel() -> String {
        return NSLocalizedString("Tentar novamente", comment: "")
    }
}
