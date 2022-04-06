//
//  SuccessView.swift
//
//
//  Created by Liviu Bosbiciu on 06.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct SuccessView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    
    public init() {
        
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text(uiMessagesSdk.successMessageTitle)
                    .foregroundColor(uiConfigSdk.textColor)
                    .font(.title)
                Text(uiMessagesSdk.successMessageBody)
                    .foregroundColor(uiConfigSdk.textColor)
                    .font(.title3)
                Spacer()
            }
            
            Button(action: {
                
            }) {
                Text(uiMessagesSdk.successButtonLabel)
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .fillButtonStyle(backgroundColor: Color(.systemRed))
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding()
    }
}

@available(macOS 11, *)
@available(iOS 14.0, *)
struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        let uiMessagesSdk = MindsSDKUIMessages.shared
        uiMessagesSdk.successMessageTitle = "Tudo certo!"
        uiMessagesSdk.successMessageBody = "Biometria por voz registrada com sucesso."
        uiMessagesSdk.successButtonLabel = "Continuar"
        return SuccessView()
    }
}
