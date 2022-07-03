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
    var action: () -> Void = {}
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text(uiMessagesSdk.confirmationMessageTitle)
                    .foregroundColor(uiConfigSdk.textColor)
                    .font(uiConfigSdk.fontFamily.isEmpty ?
                            .title : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .title)
                    )
                Text(uiMessagesSdk.confirmationMessageBody)
                    .foregroundColor(uiConfigSdk.textColor)
                    .font(uiConfigSdk.fontFamily.isEmpty ?
                            .title3 : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .title3)
                    )
                Spacer()
            }
            
            Button(action: {
                action()
            }) {
                Text(uiMessagesSdk.successButtonLabel)
                    .font(uiConfigSdk.fontFamily.isEmpty ?
                            .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                    )
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .fillButtonStyle(backgroundColor: uiConfigSdk.hexVariant400)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding()
        .preferredColorScheme(.light)
        .environment(\.colorScheme, .light)

    }
}

@available(macOS 11, *)
@available(iOS 14.0, *)
struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        let uiMessagesSdk = MindsSDKUIMessages.shared
        uiMessagesSdk.confirmationMessageTitle = "Tudo certo!"
        uiMessagesSdk.confirmationMessageBody = "Biometria por voz registrada com sucesso."
        uiMessagesSdk.successButtonLabel = "Continuar"
        return SuccessView(action: {
            
        })
    }
}
