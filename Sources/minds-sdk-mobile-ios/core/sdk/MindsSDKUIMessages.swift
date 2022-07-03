//
//  MindsSDKUIMessages.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import Foundation

@available(macOS 11, *)
@available(iOS 14.0, *)
public class MindsSDKUIMessages: ObservableObject {
    static public let shared = MindsSDKUIMessages()
    
    public init() {
        
    }
    
    @Published public var onboardingTitle: String = "Podemos iniciar a biometria por voz ?"
    @Published public var hintTextTitle: String = "Dicas"
    @Published public var hintTexts: [String] = [
        "Não peça para outra pessoa gravar",
        "Esteja em um ambiente sem barulho",
        "Fale próximo ao seu telefone",
    ]
    @Published public var startRecordingButtonLabel: String = "Sim, iniciar gravações"
    @Published public var skipRecordingButtonLabel: String = "Não, pular biometria por voz"
    @Published public var instructionTextForRecording: String = "Aperte e solte o botão abaixo para iniciar a gravação"
    @Published public var recordingIndicativeText: String = "Gravando... Leia o texto acima"
    @Published public var skipRecordingMessageTitle: String = "Pular o registro de biometria"
    @Published public var skipRecordingMessageBody: String = "Você poderá retornar depois"
    @Published public var skipRecordingConfirmLabel: String = "Pular"
    @Published public var skiprecordingDismissLabel: String = "Cancelar"
    @Published public var deleteMessageTitle: String = "Exclusão de áudio"
    @Published public var deleteMessageBody: String = "Tem certeza que deseja excluir a sua gravação? Você terá que gravar novamente"
    @Published public var confirmDeleteButtonLabel: String = "Sim, excluir áudio"
    @Published public var dismissDeleteButtonLabel: String = "Não, não excluir"
    @Published public var sendAudioButtonLabel: String = "Enviar gravações"
    @Published public var confirmAudioButtonLabel: String = ""
    @Published public var dismissAudioButtonLabel: String = ""
    @Published public var genericErrorMessageTitle: String = "Algo deu errado"
    @Published public var genericErrorMessageBody: String = "Ocorreu um erro de conexão entre nossos servidores. Por favor, tente novamente."
    @Published public var genericErrorButtonLabel: String = "Tentar novamente"
    @Published public var tryAgainLaterButtonLabel: String = "Tentar mais tarde"
    @Published public var successMessageTitle: String = "Tudo certo!"
    @Published public var successMessageBody: String = "Biometria por voz registrada com sucesso."
    @Published public var successButtonLabel: String = "Continuar"
    @Published public var loadingIndicativeTexts: [String] = [
        "Enviando gravações...",
        "Analisando formato do áudio...",
    ]
    @Published var recordingItems: [RecordingItem] = []
}
