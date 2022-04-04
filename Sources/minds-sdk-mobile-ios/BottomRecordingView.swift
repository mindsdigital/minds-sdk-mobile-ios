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
    
    @State var instructionTextForRecording: String
    @State var recordingIndicativeText: String
    @State var recording: Bool = false
    
    public init(instructionTextForRecording: String,
         recordingIndicativeText: String)
    {
        self.instructionTextForRecording = instructionTextForRecording
        self.recordingIndicativeText = recordingIndicativeText
    }
    
    public var body: some View {
        VStack {
            Text(recording ? recordingIndicativeText : instructionTextForRecording)
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
        BottomRecordingView(instructionTextForRecording: "Aperte e solte o botão abaixo para iniciar a gravação",
                            recordingIndicativeText: "Gravando... Leia o texto acima")
    }
}
