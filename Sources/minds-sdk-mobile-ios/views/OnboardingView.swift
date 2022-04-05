//
//  OnboardingView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 13.0, *)
public struct OnboardingView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    
    public init() {
        
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(uiMessagesSdk.onboardingTitle)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 20)
                Text(uiMessagesSdk.hintTextTitle)
                    .padding(.bottom, 5)
                VStack(alignment: .leading) {
                    ForEach(uiMessagesSdk.hintTexts, id: \.self) { hintText in
                        Text(hintText)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            VStack {
                NavigationLink(destination: VoiceRecordingView()) {
                    Text(uiMessagesSdk.startRecordingButtonLabel)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
                .fillButtonStyle(backgroundColor: Color(.systemBlue))
                
                Button(action: {
                    
                }) {
                    Text(uiMessagesSdk.skipRecordingButtonLabel)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
                .outlinedButtonStyle(outlineColor: Color(.black))
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding()
    }
}

@available(macOS 11, *)
@available(iOS 13.0, *)
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let uiMessagesSdk = MindsSDKUIMessages.shared
        uiMessagesSdk.onboardingTitle = "Podemos iniciar a biometria por voz ?"
        uiMessagesSdk.hintTextTitle = "Dicas"
        uiMessagesSdk.hintTexts = [
            "Não peça para outra pessoa gravar",
            "Esteja em um ambiente sem barulho",
            "Fale próximo ao seu telefone",
        ]
        uiMessagesSdk.startRecordingButtonLabel = "Sim, iniciar gravações"
        uiMessagesSdk.skipRecordingButtonLabel = "Não, pular biometria por voz"
        
        return OnboardingView()
            .environmentObject(uiMessagesSdk)
    }
}
