//
//  OnboardingView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct OnboardingView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    @Environment(\.presentationMode) var presentation
    
    public init() {
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(uiMessagesSdk.onboardingTitle)
                    .foregroundColor(uiConfigSdk.textColor)
                    .font(uiConfigSdk.fontFamily.isEmpty ?
                            .title : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .title)
                    )
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 20)
                Text(uiMessagesSdk.hintTextTitle)
                    .foregroundColor(uiConfigSdk.textColor)
                    .font(uiConfigSdk.fontFamily.isEmpty ?
                            .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                    )
                    .padding(.bottom, 5)
                VStack(alignment: .leading) {
                    ForEach(uiMessagesSdk.hintTexts, id: \.self) { hintText in
                        Text("• " + hintText)
                            .foregroundColor(uiConfigSdk.textColor)
                            .font(uiConfigSdk.fontFamily.isEmpty ?
                                    .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                            )
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            VStack {
                NavigationLink(destination: VoiceRecordingView()) {
                    Text(uiMessagesSdk.startRecordingButtonLabel)
                        .foregroundColor(Color.white)
                        .font(uiConfigSdk.fontFamily.isEmpty ?
                                .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                        )
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
                .fillButtonStyle(backgroundColor: uiConfigSdk.hexVariant400)
                
                if (uiConfigSdk.showBiometricsSkipButton) {
                    Button(action: {
                        presentation.wrappedValue.dismiss()
                    }) {
                        Text(uiMessagesSdk.skipRecordingButtonLabel)
                            .foregroundColor(uiConfigSdk.hexVariant400)
                            .font(uiConfigSdk.fontFamily.isEmpty ?
                                    .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                            )
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .outlinedButtonStyle(outlineColor: uiConfigSdk.hexVariant400)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding()
        .onAppear {
            for i in 0..<uiMessagesSdk.recordingItems.count {
                uiMessagesSdk.recordingItems[i].recording = nil
            }
        }
    }
}

@available(macOS 11, *)
@available(iOS 14.0, *)
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
    }
}
