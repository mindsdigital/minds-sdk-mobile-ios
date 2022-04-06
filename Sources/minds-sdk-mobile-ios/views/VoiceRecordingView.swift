//
//  VoiceRecordingView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct VoiceRecordingView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    @State var showActionSheet: Bool = false
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(uiMessagesSdk.recordingItems, id: \.self) { recordingItem in
                        Text(recordingItem.key)
                            .foregroundColor(uiConfigSdk.textColor)
                        Text(recordingItem.value)
                            .foregroundColor(uiConfigSdk.textColor)
                        RecordingItemView(onDeleteAction: {
                            self.showActionSheet = true
                        })
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            BottomRecordingView()
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding()
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text(uiMessagesSdk.deleteMessageTitle),
                        message: Text(uiMessagesSdk.deleteMessageBody),
                        buttons: [
                            .cancel(
                                Text(uiMessagesSdk.dismissDeleteButtonLabel)),
                            .destructive(
                                Text(uiMessagesSdk.confirmDeleteButtonLabel),
                                action: {
                                }
                            )
                        ]
            )
        }
    }
}

@available(macOS 11, *)
@available(iOS 14.0, *)
struct VoiceRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        let uiMessagesSdk = MindsSDKUIMessages.shared
        var recordingItems: [RecordingItem] = []
        recordingItems.append(RecordingItem(key: "NOME COMPLETO",
                                            value: "Divino Borges de Oliveira Filho"))
        recordingItems.append(RecordingItem(key: "DATA DE NASCIMENTO",
                                            value: "18/09/1967"))
        uiMessagesSdk.recordingItems = recordingItems
        uiMessagesSdk.recordingIndicativeText = "Gravando... Leia o texto acima"
        uiMessagesSdk.instructionTextForRecording = "Aperte e solte o botão abaixo para iniciar a gravação"
        uiMessagesSdk.deleteMessageTitle = "Exclusão de áudio"
        uiMessagesSdk.deleteMessageBody = "Tem certeza que deseja excluir a sua gravação? Você terá que gravar novamente"
        uiMessagesSdk.confirmDeleteButtonLabel = "Sim, excluir áudio"
        uiMessagesSdk.dismissDeleteButtonLabel = "Não, não excluir"
        
        return VoiceRecordingView()
    }
}
