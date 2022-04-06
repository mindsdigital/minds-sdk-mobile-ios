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
            Text(recording ? uiMessagesSdk.recordingIndicativeText : uiMessagesSdk.instructionTextForRecording)
                .foregroundColor(uiConfigSdk.textColor)
            Button(action: {
                recording.toggle()
            }) {
                ZStack {
                    Circle()
                        .background(Color.black)
                        .frame(width: 56, height: 56)
                    Image(uiImage: UIImage(named: "voice", in: .module, with: nil)!)
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                }
            }
            .buttonStyle(.plain)
            .cornerRadius(100)
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
