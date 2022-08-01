//
//  SwiftUIView.swift
//  
//
//  Created by Divino Borges on 28/07/22.
//

import SwiftUI
import AVFAudio

struct VoiceRecordView: View {
    @StateObject var viewModel = VoiceRecordViewModel()
    @Binding var showBiometricsFlow: Bool
    private var dismiss: (() -> Void)?

    @State var fadeIn: Bool = false
    @State var fadeOut: Bool = false

    init(showBiometricsFlow: Binding<Bool>,
         dismiss: (() -> Void)? = nil) {
        self._showBiometricsFlow = showBiometricsFlow
        self.dismiss = dismiss
    }

    var body: some View {
        NavigationView {
            if viewModel.state == .loading {
                LoadingView()
            } else {
                VStack(spacing: 0.0) {
                    VStack(alignment: .leading, spacing: 0.0) {
                        Text(MindsStrings.voiceRecordingTitle())
                            .font(.headline)
                            .padding(0.0)
                        Text(MindsStrings.voiceRecordingSubtitle())
                            .font(.subheadline)
                            .padding(0.0)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(viewModel.livenessText())
                            .font(.largeTitle)
                            .padding()
                    }
                    Spacer()
                    VStack {
                        HStack {
                            if (viewModel.state == .recording) {
                                LottieView(name: LottieAnimations.audioRecordingLottieAnimation)

                            }
                        }.frame(maxWidth: .infinity, minHeight: 80.0, maxHeight: 80.0)

                        RecordingButton(longPressMinDuration: 0.3,
                                        onLongPress: viewModel.startRecording,
                                        onTap: nil,
                                        onRelease: viewModel.stopRecording)
                        VStack {
                            Text("Minds Digital")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            Text("Versão \(Version.versionCode)")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }.padding()

                    }
                }
            }
        }
        .alert(isPresented: viewModel.state.isError) {
            Alert(
                title: Text(MindsStrings.voiceRecordingAlertTitle()),
                message: Text(MindsStrings.voiceRecordingAlertSubtitle()),
                primaryButton: .destructive(Text(MindsStrings.voiceRecordingAlertNeutralButtonLabel()),
                                            action: {
                                                viewModel.doBiometricsLater()
                                            }),
                secondaryButton: .default(Text(MindsStrings.voiceRecordingAlertButtonLabel()))
            )
        }
        .onAppear(perform: {
            withAnimation(Animation.easeIn(duration: 1)) {
                self.fadeIn = true
                self.fadeOut = false
            }
        })
        .onDisappear(perform: {
            withAnimation(Animation.easeIn(duration: 1)) {
                self.fadeOut = true
                self.fadeIn = false
            }
        })
        .navigationBarHidden(true)
        .disableRotation()
        .preferredColorScheme(.light)
        .opacity((fadeIn || fadeOut) ? 1 : 0)
    }
}
