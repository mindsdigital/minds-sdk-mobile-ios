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
    var invalidLength: Bool

    public init(invalidLength: Bool, action: @escaping () -> Void, tryAgain: (() -> Void)? = nil) {
        self.invalidLength = invalidLength
        self.action = action
        self.tryAgain = tryAgain
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text(getErrorTitle())
                    .foregroundColor(uiConfigSdk.textColor)
                    .font(customFont(defaultFont: .title, defaultStyle: .title))
                Text(getErrorBody())
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
                        Text(getErrorButtonLabel())
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
        .disableRotation()
    }

    private func getErrorTitle() -> String {
        if invalidLength {
            return uiMessagesSdk.invalidLengthErrorMessageTitle
        }
        return uiMessagesSdk.genericErrorMessageTitle
    }

    private func getErrorBody() -> String {
        if invalidLength {
            return uiMessagesSdk.invalidLengthErrorMessageBody
        }
        return uiMessagesSdk.genericErrorMessageBody
    }

    private func getErrorButtonLabel() -> String {
        if invalidLength {
            return uiMessagesSdk.invalidLengthErrorButtonLabel
        }
        return uiMessagesSdk.genericErrorButtonLabel
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
        return ErrorView(invalidLength: false, action: {
            
        })
    }
}
