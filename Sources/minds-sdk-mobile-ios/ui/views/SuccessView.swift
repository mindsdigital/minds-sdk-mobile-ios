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
                    .font(uiConfigSdk.getFontFamily().isEmpty ?
                            .title : .custom(uiConfigSdk.getFontFamily(), size: uiConfigSdk.getTypographyScale(), relativeTo: .title)
                    )
                Text(uiMessagesSdk.confirmationMessageBody)
                    .foregroundColor(uiConfigSdk.textColor)
                    .font(customFont(defaultFont: .title3, defaultStyle: .title3))
                Spacer()
            }
            
            Button(action: {
                action()
            }) {
                Text(uiMessagesSdk.successButtonLabel)
                    .font(customFont(defaultFont: .body, defaultStyle: .body))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .fillButtonStyle(backgroundColor: uiConfigSdk.hexVariant400)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding()
        .preferredColorScheme(.light)
        .environment(\.colorScheme, .light)
        .disableRotation()

    }

    private func customFont(defaultFont: Font, defaultStyle: Font.TextStyle) -> Font {
        let customFont: Font = .custom(uiConfigSdk.getFontFamily(), size: uiConfigSdk.getTypographyScale(), relativeTo: defaultStyle)
        return uiConfigSdk.getFontFamily().isEmpty ? defaultFont : customFont
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
