//
//  BottomRecordingView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public struct BottomRecordingView: View {
    @EnvironmentObject var uiMessagesSdk: MindsSDKUIMessages
    @State var recording: Bool = false
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            Text(recording ? uiMessagesSdk.recordingIndicativeText : uiMessagesSdk.instructionTextForRecording)
            Button(action: {
                recording.toggle()
            }) {
                Text("RECORD") // todo: change this
            }
        }
    }
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct BottomRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        let uiMessagesSdk = MindsSDKUIMessages()
        uiMessagesSdk.recordingIndicativeText = "Gravando... Leia o texto acima"
        uiMessagesSdk.instructionTextForRecording = "Aperte e solte o botão abaixo para iniciar a gravação"
        return BottomRecordingView()
            .environmentObject(uiMessagesSdk)
    }
}
