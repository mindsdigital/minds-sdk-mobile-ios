//
//  LoadingView.swift
//  
//
//  Created by Liviu Bosbiciu on 05.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct LoadingView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    private var textFont: Font = .body

    public init() {
        let customFont = Font.custom(uiConfigSdk.getFontFamily(), size: uiConfigSdk.getTypographyScale(), relativeTo: .body)
        self.textFont = uiConfigSdk.getFontFamily().isEmpty ? .body : customFont
    }
    
    public var body: some View {
        VStack {
            Spacer()
            if (uiConfigSdk.getLogoImage().isEmpty) {
                Image(uiImage: UIImage(named: "robot", in: .module, with: nil) ?? UIImage())
            } else {
                Image(uiConfigSdk.getLogoImage())
            }

            SequentialTextWithAnimation(texts: uiMessagesSdk.loadingIndicativeTexts,
                                        textColor: uiConfigSdk.textColor,
                                        font: textFont)

            Spacer()
        }
        .preferredColorScheme(.light)
        .environment(\.colorScheme, .light)
        .disableRotation()
    }
}

@available(macOS 11, *)
@available(iOS 14.0, *)
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
