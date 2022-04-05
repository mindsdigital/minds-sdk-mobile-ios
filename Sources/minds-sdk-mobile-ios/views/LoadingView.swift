//
//  LoadingView.swift
//  
//
//  Created by Liviu Bosbiciu on 05.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 13.0, *)
public struct LoadingView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Image(uiImage: UIImage(named: "robot", in: .module, with: nil)!)
            ForEach(uiMessagesSdk.loadingIndicativeTexts, id: \.self) { loadingIndicativeText in
                Text(loadingIndicativeText)
                    .foregroundColor(uiConfigSdk.textColor)
            }
            Spacer()
        }
    }
}

@available(macOS 11, *)
@available(iOS 13.0, *)
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
