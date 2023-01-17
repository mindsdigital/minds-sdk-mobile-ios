//
//  SwiftUIView.swift
//  
//
//  Created by Divino Borges on 28/07/22.
//

import SwiftUI
import AVFAudio

@available(iOS 13.0, *)
public struct VoiceRecordView_old: View {
    @ObservedObject var viewModel: VoiceRecordViewModel_old
    @State var fadeIn: Bool = false
    @State var showTooltip: Bool = false
    @Binding var voiceRecordingFlowActive: Bool

    public init(delegate: MindsSDKDelegate?,
                voiceRecordingFlowActive: Binding<Bool>,
                completion: (() -> Void)? = nil) {
        self._voiceRecordingFlowActive = voiceRecordingFlowActive
        self.viewModel = VoiceRecordViewModel_old(mindsDelegate: delegate,
                                                  voiceRecordingFlowActive: voiceRecordingFlowActive,
                                                  completion: completion)
    }

    @ViewBuilder
    public var body: some View {
        if viewModel.state == .loading {
            LoadingView()
        } else {
            defaultView()
        }
    }

    private func defaultView() -> some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(MindsSDKConfigs.shared.voiceRecordingTitle())
                            .font(.headline)
                            .foregroundColor(MindsSDKConfigs.shared.voiceRecordTitleColor())
                        Spacer()
                    }
                    HStack {
                        Text(MindsSDKConfigs.shared.voiceRecordingSubtitle())
                            .font(.subheadline)
                            .foregroundColor(MindsSDKConfigs.shared.voiceRecordSubtitleColor())
                        Spacer()
                    }
                }

                Spacer()

                VStack(spacing: 24) {
                    HStack {
                        Text(viewModel.livenessText.result ?? "")
                            .font(.largeTitle)
                            .lineLimit(nil)
                            .minimumScaleFactor(0.6)
                            .foregroundColor(MindsSDKConfigs.shared.voiceRecordMainTextColor())
                        Spacer()
                    }

                    HStack {
                        if (viewModel.state == .recording) {
                            recordingWaveAndTimer()
                        }
                    }.frame(maxWidth: .infinity, minHeight: 80.0, maxHeight: 80.0)
                }

                Spacer()

                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        RecordingButton(longPressMinDuration: 0.3,
                                        onLongPress: viewModel.startRecording,
                                        onTap: { self.showTooltip = true },
                                        onRelease: viewModel.stopRecording)
                    }

                    VStack {
                        Text("Minds Digital")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                        Text("Versão \(Version.versionCode)")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                    }
                    .padding(.top, 24)
                }
            }
            if showTooltip {
                Tooltip(text: MindsSDKConfigs.shared.voiceRecordingButtonInstruction()) {
                    self.showTooltip = false
                }
                .padding(.bottom, 160)
            }
        }
        .padding(24)
        .alert(isPresented: viewModel.state.isError) {
            viewModel.alert()
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
            TimerComponent(stoped: viewModel.setAudioDuration)
        }
    }

    private func dispatchAnimationOnMainThread() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            withAnimation(Animation.easeIn(duration: 1)) {
                self.fadeIn = true
            }
        }
    }
}
