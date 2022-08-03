//
//  SwiftUIView.swift
//  
//
//  Created by Divino Borges on 28/07/22.
//

import SwiftUI
import AVFAudio

struct VoiceRecordView: View {
    @ObservedObject var viewModel: VoiceRecordViewModel
    @State var fadeIn: Bool = false

    init(delegate: MindsSDKDelegate?,
         completion: (() -> Void)? = nil) {
        self.viewModel = VoiceRecordViewModel(mindsDelegate: delegate,
                                              completion: completion)
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
                                recordingWaveAndTimer()
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
            alert()
        }
        .onAppear(perform: {
            self.dispatchAnimationOnMainThread()
        })
        .opacity(fadeIn ? 1 : 0)
        .navigationBarHidden(true)
        .disableRotation()
        .preferredColorScheme(.light)
    }

    private func recordingWaveAndTimer() -> some View {
        VStack {
            LottieView(name: LottieAnimations.audioRecordingLottieAnimation)
            TimerComponent { seconds in
                viewModel.audioDuration = seconds
            }
        }
    }

    private func dispatchAnimationOnMainThread() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            withAnimation(Animation.easeIn(duration: 1)) {
                self.fadeIn = true
            }
        }
    }

    private func alert() -> Alert? {
        if case let VoiceRecordState.error(errorType) = viewModel.state {
            return Alert(
                    title: Text(errorType.title),
                    message: Text(errorType.subtitle),
                    primaryButton: .destructive(Text(errorType.neutralButtonLabel ?? ""),
                                                action: { viewModel.doBiometricsLater() }),
                    secondaryButton: .default(Text(errorType.primaryActionLabel)))
        }
    }
}
