//
//  ErrorView.swift
//  
//
//  Created by Liviu Bosbiciu on 06.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 13.0, *)
public struct ErrorView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    
    public init() {
        
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text(uiMessagesSdk.genericErrorMessageTitle)
                    .foregroundColor(uiConfigSdk.textColor)
//                    .font(uiConfigSdk.fontFamily.isEmpty ?
//                            .custom(size: uiConfigSdk.)
//                          : .custom("Georgia", size: 24, relativeTo: .title))
                Text(uiMessagesSdk.genericErrorMessageBody)
                    .foregroundColor(uiConfigSdk.textColor)
                Spacer()
            }
            
            Button(action: {
                
            }) {
                Text(uiMessagesSdk.genericErrorButtonLabel)
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .fillButtonStyle(backgroundColor: Color(.systemRed))
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding()
    }
}

@available(macOS 11, *)
@available(iOS 13.0, *)
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        let uiMessagesSdk = MindsSDKUIMessages.shared
        uiMessagesSdk.genericErrorMessageTitle = "Algo deu errado"
        uiMessagesSdk.genericErrorMessageBody = "Ocorreu um erro de conexão entre nossos servidores. Por favor, tente novamente."
        uiMessagesSdk.genericErrorButtonLabel = "Tentar novamente"
        return ErrorView()
    }
}
