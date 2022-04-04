//
//  VoiceRecordingView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public struct VoiceRecordingView: View {
    @EnvironmentObject var uiMessagesSdk: MindsSDKUIMessages
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(uiMessagesSdk.recordingItems, id: \.self) { recordingItem in
                        Text(recordingItem.key)
                        Text(recordingItem.value)
                            .padding(.bottom)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            BottomRecordingView()
                .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
    }
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct VoiceRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        let uiMessagesSdk = MindsSDKUIMessages()
        var recordingItems: [RecordingItem] = []
        recordingItems.append(RecordingItem(key: "NOME COMPLETO",
                                            value: "Divino Borges de Oliveira Filho"))
        recordingItems.append(RecordingItem(key: "DATA DE NASCIMENTO",
                                            value: "18/09/1967"))
        uiMessagesSdk.recordingItems = recordingItems
        uiMessagesSdk.recordingIndicativeText = "Gravando... Leia o texto acima"
        uiMessagesSdk.instructionTextForRecording = "Aperte e solte o botão abaixo para iniciar a gravação"
        
        return VoiceRecordingView()
            .environmentObject(uiMessagesSdk)
    }
}
