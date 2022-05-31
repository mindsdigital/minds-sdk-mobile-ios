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
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            Spacer()
            if (uiConfigSdk.loadingImage.isEmpty) {
                Image(uiImage: UIImage(named: "robot", in: .module, with: nil) ?? UIImage())
            } else {
                Image(uiConfigSdk.loadingImage)
            }
            
            ForEach(uiMessagesSdk.loadingIndicativeTexts, id: \.self) { loadingIndicativeText in
                Text(loadingIndicativeText)
                    .foregroundColor(uiConfigSdk.textColor)
                    .font(uiConfigSdk.fontFamily.isEmpty ?
                            .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                    )
            }
            Spacer()
        }
        .preferredColorScheme(.light)
    }
}

@available(macOS 11, *)
@available(iOS 14.0, *)
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
