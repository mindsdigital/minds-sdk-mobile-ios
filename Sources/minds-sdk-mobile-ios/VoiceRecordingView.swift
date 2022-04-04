//
//  VoiceRecordingView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct VoiceRecordingView: View {
    
    @State var recordingItems: [RecordingItem]
    @State var instructionTextForRecording: String = "Press record" // todo: change this
    @State var recordingIndicativeText: String = "Loading" // todo: change this
    
    public init(
        recordingItems: [RecordingItem]
    ) {
        self.recordingItems = recordingItems
    }
    public var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(recordingItems, id: \.self) { recordingItem in
                        Text(recordingItem.key)
                        Text(recordingItem.value)
                            .padding(.bottom)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            BottomRecordingView(
                instructionTextForRecording: instructionTextForRecording,
                recordingIndicativeText: recordingIndicativeText
            )
                .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
    }
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct VoiceRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceRecordingView(recordingItems: [
            RecordingItem(key: "NOME COMPLETO",
                          value: "Divino Borges de Oliveira Filho"),
            RecordingItem(key: "DATA DE NASCIMENTO",
                          value: "18/09/1967")
        ])
    }
}
