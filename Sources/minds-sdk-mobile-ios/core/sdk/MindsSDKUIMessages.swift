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
    
    @Published var onboardingTitle: String = "Podemos iniciar a biometria por voz ?"
    @Published var hintTextTitle: String = "Dicas"
    @Published var hintTexts: [String] = [
        "Não peça para outra pessoa gravar",
        "Esteja em um ambiente sem barulho",
        "Fale próximo ao seu telefone",
    ]
    @Published var startRecordingButtonLabel: String = "Sim, iniciar gravações"
    @Published var skipRecordingButtonLabel: String = "Não, pular biometria por voz"
    @Published var instructionTextForRecording: String = "Aperte e solte o botão abaixo para iniciar a gravação"
    @Published var recordingIndicativeText: String = "Gravando... Leia o texto acima"
    @Published var skipMessageTitle: String = "Pular o registro de biometria"
    @Published var skipMessageBody: String = "Você poderá retornar depois"
    @Published var confirmSkipButtonLabel: String = "Pular"
    @Published var dismissSkipButtonLabel: String = "Cancelar"
    @Published var deleteMessageTitle: String = "Exclusão de áudio"
    @Published var deleteMessageBody: String = "Tem certeza que deseja excluir a sua gravação? Você terá que gravar novamente"
    @Published var confirmDeleteButtonLabel: String = "Sim, excluir áudio"
    @Published var dismissDeleteButtonLabel: String = "Não, não excluir"
    @Published var audioSendButtonLabel: String = "Enviar gravações"
    @Published var confirmAudioButtonLabel: String = ""
    @Published var dismissAudioButtonLabel: String = ""
    @Published var genericErrorMessageTitle: String = "Algo deu errado"
    @Published var genericErrorMessageBody: String = "Ocorreu um erro de conexão entre nossos servidores. Por favor, tente novamente."
    @Published var genericErrorButtonLabel: String = "Tentar novamente"
    @Published var tryAgainLaterButtonLabel: String = "Tentar mais tarde"
    @Published var confirmationMessageTitle: String = "Tudo certo!"
    @Published var confirmationMessageBody: String = "Biometria por voz registrada com sucesso."
    @Published var successButtonLabel: String = "Continuar"
    @Published var loadingIndicativeTexts: [String] = [
        "Enviando gravações...",
        "Analisando formato do áudio...",
    ]
    @Published var recordingItems: [RecordingItem] = []

       public func setRecordingItems(_ items: [RecordingItem]) {
           self.recordingItems = items
       }

       public func setConfirmationMessageBody(_ messageBody: String) {
           self.confirmationMessageBody = messageBody
       }

       public func setConfirmationMessageTitle(_ message: String) {
           self.confirmationMessageTitle = message
       }

       public func setGenericErrorMessageTitle(_ message: String) {
           self.genericErrorMessageTitle = message
       }

       public func setGenericErrorMessageBody(_ message: String) {
           self.genericErrorMessageBody = message
       }

       public func setGenericErrorButtonLabel(_ label: String) {
           self.genericErrorButtonLabel = label
       }

       public func setSuccessButtonLabel(_ label: String) {
           self.successButtonLabel = label
       }

       public func setLoadingIndicativeTexts(_ texts: [String]) {
           self.loadingIndicativeTexts = texts
       }

       public func setDeleteMessageTitle(_ text: String) {
           self.deleteMessageTitle = text
       }

       public func setDeleteMessageBody(_ text: String) {
           self.deleteMessageBody = text
       }

       public func setConfirmDeleteButtonLabel(_ text: String) {
           self.confirmDeleteButtonLabel = text
       }

       public func setDismissDeleteButtonLabel(_ text: String) {
           self.dismissDeleteButtonLabel = text
       }

       public func setAudioSendButtonLabel(_ text: String) {
           self.audioSendButtonLabel = text
       }

       public func setOnBoardingTitle(_ text: String) {
           self.onboardingTitle = text
       }

       public func setHintTextTitle(_ text: String) {
           self.hintTextTitle = text
       }

       public func setHintTexts(_ texts: [String]) {
           self.hintTexts = texts
       }

       public func setStartRecordingButtonLabel(_ text: String) {
           self.startRecordingButtonLabel = text
       }

       public func setSkipRecordingButtonLabel(_ text: String) {
           self.skipRecordingButtonLabel = text
       }

       public func setInstructionTextForRecording(_ text: String) {
           self.instructionTextForRecording = text
       }

       public func setRecordingIndicativeText(_ text: String) {
           self.recordingIndicativeText = text
       }

       public func setSkipMessageTitle(_ text: String) {
           self.skipMessageTitle = text
       }

       public func setSkipMessageBody(_ text: String) {
           self.skipMessageBody = text
       }

       public func setDismissSkipButtonLabel(_ text: String) {
           self.dismissSkipButtonLabel = text
       }

       public func setConfirmSkipButtonLabel(_ text: String) {
           self.confirmSkipButtonLabel = text
       }

       public func setTryAgainLaterButtonLabel(_ text: String) {
           self.tryAgainLaterButtonLabel = text
       }
}
