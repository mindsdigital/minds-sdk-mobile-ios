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
                    .font(customFont(defaultFont: .title, defaultStyle: .title))
                Text(uiMessagesSdk.genericErrorMessageBody)
                    .foregroundColor(uiConfigSdk.textColor)
                    .font(customFont(defaultFont: .title3, defaultStyle: .title3))
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
                            .font(customFont(defaultFont: .body, defaultStyle: .body))
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .fillButtonStyle(backgroundColor: Color(.systemRed))
                    .padding(.bottom, 5)

                    if uiConfigSdk.showTryAgainLater() {
                        Button(action: {
                            tryAgain?()
                        }) {
                            Text(uiMessagesSdk.tryAgainLaterButtonLabel)
                                .font(customFont(defaultFont: .body, defaultStyle: .body))
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

    private func customFont(defaultFont: Font, defaultStyle: Font.TextStyle) -> Font {
        let customFont: Font = .custom(uiConfigSdk.getFontFamily(), size: uiConfigSdk.getTypographyScale(), relativeTo: defaultStyle)
        return uiConfigSdk.getFontFamily().isEmpty ? defaultFont : customFont
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
