//
//  SwiftUIView.swift
//  
//
//  Created by Liviu Bosbiciu on 05.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
struct CustomActionSheet : View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    @State var count = 0
    
    var body : some View{
        
        VStack(spacing: 15) {
            
            Text(uiMessagesSdk.deleteMessageTitle)
                .foregroundColor(uiConfigSdk.textColor)
                .font(uiConfigSdk.fontFamily.isEmpty ?
                        .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                )
            
            Text(uiMessagesSdk.deleteMessageBody)
                .foregroundColor(uiConfigSdk.textColor)
                .font(uiConfigSdk.fontFamily.isEmpty ?
                        .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                )
            
            Button(action: {
                
            }) {
                Text(uiMessagesSdk.dismissDeleteButtonLabel)
                    .font(uiConfigSdk.fontFamily.isEmpty ?
                            .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                    )
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .fillButtonStyle(backgroundColor: Color(.systemRed))
            
            Button(action: {
                
            }) {
                Text(uiMessagesSdk.dismissAudioButtonLabel)
                    .font(uiConfigSdk.fontFamily.isEmpty ?
                            .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                    )
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .foregroundColor(Color(.black))
            
        }.padding(.bottom, 10)
            .padding(.horizontal)
            .padding(.top,20)
            .cornerRadius(25)
        
    }
}

@available(macOS 11, *)
@available(iOS 14.0, *)
struct CustomActionSheet_Previews: PreviewProvider {
    static var previews: some View {
        let uiMessagesSdk = MindsSDKUIMessages.shared
        uiMessagesSdk.deleteMessageTitle = "Exclusão de áudio"
        uiMessagesSdk.deleteMessageBody = "Tem certeza que deseja excluir a sua gravação? Você terá que gravar novamente"
        uiMessagesSdk.dismissAudioButtonLabel = "Não, não excluir"
        uiMessagesSdk.dismissDeleteButtonLabel = "Sim, excluir áudio"
        return CustomActionSheet()
    }
}
