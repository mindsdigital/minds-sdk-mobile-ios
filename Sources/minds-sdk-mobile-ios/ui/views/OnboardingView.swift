//
//  OnboardingView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct OnboardingView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    @ObservedObject var sdk = MindsSDK.shared
    @Environment(\.presentationMode) var presentation
    
    @State var showActionSheet: Bool = false
    @Binding var voiceRecordingFlowActive: Bool
    
    public init(voiceRecordingFlowActive: Binding<Bool>) {
        self._voiceRecordingFlowActive = voiceRecordingFlowActive
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text(uiMessagesSdk.onboardingTitle)
                            .foregroundColor(uiConfigSdk.textColor)
                            .font(uiConfigSdk.fontFamily.isEmpty ?
                                .title : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .title)
                            )
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 20)
                        Text(uiMessagesSdk.hintTextTitle)
                            .foregroundColor(uiConfigSdk.textColor)
                            .font(uiConfigSdk.fontFamily.isEmpty ?
                                .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                            )
                            .padding(.bottom, 5)
                        VStack(alignment: .leading) {
                            ForEach(uiMessagesSdk.hintTexts, id: \.self) { hintText in
                                Text("• " + hintText)
                                    .foregroundColor(uiConfigSdk.textColor)
                                    .font(uiConfigSdk.fontFamily.isEmpty ?
                                        .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 90)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            ZStack {
                Color(UIColor.systemBackground)
                    .frame(maxWidth: .infinity, maxHeight: 90)
                VStack {
                    NavigationLink(destination: VoiceRecordingView(voiceRecordingFlowActive: $voiceRecordingFlowActive)) {
                        Text(uiMessagesSdk.startRecordingButtonLabel)
                            .foregroundColor(Color.white)
                            .font(uiConfigSdk.fontFamily.isEmpty ?
                                .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                            )
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .isDetailLink(false)
                    .fillButtonStyle(backgroundColor: uiConfigSdk.hexVariant400)
                    .padding(.bottom, 5)
                    
                    if (uiConfigSdk.showSkipBiometrics()) {
                        Button(action: {
                            self.showActionSheet = true
                        }) {
                            Text(uiMessagesSdk.skipRecordingButtonLabel)
                                .foregroundColor(uiConfigSdk.hexVariant400)
                                .font(uiConfigSdk.fontFamily.isEmpty ?
                                    .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                                )
                                .frame(maxWidth: .infinity, maxHeight: 40)
                        }
                        .outlinedButtonStyle(outlineColor: uiConfigSdk.hexVariant400)
                        .padding(.bottom, 5)

                    }
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .preferredColorScheme(.light)
        .environment(\.colorScheme, .light)
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text(uiMessagesSdk.skipRecordingMessageTitle),
                        message: Text(uiMessagesSdk.skipRecordingMessageBody),
                        buttons: [
                            .cancel(
                                Text(uiMessagesSdk.skiprecordingDismissLabel)),
                            .default(
                                Text(uiMessagesSdk.skipRecordingConfirmLabel),
                                action: {
                                    presentation.wrappedValue.dismiss()
                                }
                            )
                        ]
            )
        }
        .onAppear {
            for i in 0..<uiMessagesSdk.recordingItems.count {
                uiMessagesSdk.recordingItems[i].recording = nil
            }
        }
    }
}
