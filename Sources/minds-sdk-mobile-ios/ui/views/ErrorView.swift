//
//  ErrorView.swift
//  
//
//  Created by Liviu Bosbiciu on 06.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct ErrorView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    var action: () -> Void = {}
    var tryAgain: (() -> Void)? = {}

    public init(action: @escaping () -> Void, tryAgain: (() -> Void)? = nil) {
        self.action = action
        self.tryAgain = tryAgain
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text(uiMessagesSdk.genericErrorMessageTitle)
                    .foregroundColor(uiConfigSdk.textColor)
                    .font(uiConfigSdk.fontFamily.isEmpty ?
                            .title : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .title)
                    )
                Text(uiMessagesSdk.genericErrorMessageBody)
                    .foregroundColor(uiConfigSdk.textColor)
                    .font(uiConfigSdk.fontFamily.isEmpty ?
                            .title3 : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .title3)
                    )
                Spacer()
            }

            ZStack {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: 90)

                VStack {
                    Button(action: {
                        action()
                    }) {
                        Text(uiMessagesSdk.genericErrorButtonLabel)
                            .font(uiConfigSdk.fontFamily.isEmpty ?
                                .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                            )
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .fillButtonStyle(backgroundColor: Color(.systemRed))
                    .padding(.bottom, 5)

                    if uiConfigSdk.showTryAgainLater() {
                        Button(action: {
                            tryAgain?()
                        }) {
                            Text(uiMessagesSdk.tryAgainLaterButtonLabel)
                                .font(uiConfigSdk.fontFamily.isEmpty ?
                                    .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                                )
                                .frame(maxWidth: .infinity, maxHeight: 40)
                        }
                        .outlinedButtonStyle(outlineColor: uiConfigSdk.hexVariant400)
                        .padding(.bottom, 5)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding()
        .preferredColorScheme(.light)
        .environment(\.colorScheme, .light)
    }
}

@available(macOS 11, *)
@available(iOS 14.0, *)
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        let uiMessagesSdk = MindsSDKUIMessages.shared
        uiMessagesSdk.genericErrorMessageTitle = "Algo deu errado"
        uiMessagesSdk.genericErrorMessageBody = "Ocorreu um erro de conexão entre nossos servidores. Por favor, tente novamente."
        uiMessagesSdk.genericErrorButtonLabel = "Tentar novamente"
        return ErrorView(action: {
            
        })
    }
}
