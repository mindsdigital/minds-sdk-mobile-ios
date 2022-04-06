//
//  BottomRecordingView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct BottomRecordingView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    @State var recording: Bool = false
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            Divider()
            Group {
                Text(recording ? uiMessagesSdk.recordingIndicativeText : uiMessagesSdk.instructionTextForRecording)
                    .foregroundColor(uiConfigSdk.textColor)
                    .padding(.top, 5)
                Button(action: {
                    recording.toggle()
                }) {
                    Image(uiImage: UIImage(named: "voice", in: .module, with: nil)!)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .frame(width: 56, height: 56)
                .background(Color(.systemBlue))
                .cornerRadius(100)
            }
            .padding(.horizontal)
        }
    }
}

@available(macOS 11, *)
@available(iOS 14.0, *)
struct BottomRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        let uiMessagesSdk = MindsSDKUIMessages.shared
        uiMessagesSdk.recordingIndicativeText = "Gravando... Leia o texto acima"
        uiMessagesSdk.instructionTextForRecording = "Aperte e solte o botão abaixo para iniciar a gravação"
        return BottomRecordingView()
    }
}
