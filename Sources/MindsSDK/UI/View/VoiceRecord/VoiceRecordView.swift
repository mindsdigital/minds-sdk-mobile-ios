//
//  VoiceRecordView.swift
//  
//
//  Created by Guilherme Domingues on 11/01/23.
//

import UIKit
import Lottie

final class VoiceRecordView: UIView {

    private enum Layout: CGFloat {
        case horizontalPadding = 24
        case verticalPadding = 48
        case voiceRecordTopAnchor = 16
        case voiceRecordBottomAnchor = 24.0000001
        case topAnchorFromRecordButton = 12
        case footerViewBottomAnchor = 4
        case tooltipWidth = 200
        case tooltipHeight = 50
    }
    
    private enum FontSizes: CGFloat {
        case header = 14
        case headerSubtitle = 12
        case voiceRecordLabel = 30
    }

    private lazy var headerTitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = MindsSDKConfigs.shared.voiceRecordingTitle()
        $0.textColor = MindsSDKConfigs.shared.voiceRecordTitleColor()
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: FontSizes.header.rawValue, weight: .medium)
        return $0
    }(UILabel())

    private lazy var headerSubtitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = MindsSDKConfigs.shared.voiceRecordingSubtitle()
        $0.textColor = MindsSDKConfigs.shared.voiceRecordSubtitleColor()
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: FontSizes.headerSubtitle.rawValue, weight: .light)
        return $0
    }(UILabel())

    private lazy var voiceRecordLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = viewModel.livenessText.result
        $0.textColor = MindsSDKConfigs.shared.voiceRecordMainTextColor()
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: FontSizes.voiceRecordLabel.rawValue, weight: .regular)
        $0.minimumScaleFactor = 0.7
        return $0
    }(UILabel())

    private lazy var lottieView: AnimationView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let animation = Animation.named(LottieAnimations.audioRecordingLottieAnimation, bundle: Bundle.module)
        $0.animation = animation
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.play()
        $0.isHidden = true
        return $0
    }(AnimationView(frame: .zero))

    private lazy var timerComponent: TimerComponent = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
        return $0
    }(TimerComponent(viewModel: viewModel.timerViewModel))

    private lazy var recordVoiceButton: RecordingButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.onLongPressStart = { [weak self] in
            self?.viewModel.longPressStarted()
            self?.lottieView.isHidden = false
            self?.lottieView.play()
            self?.timerComponent.isHidden = false
            self?.tooltip.alpha = 0
        }

        $0.onLongPressEnd = { [weak self] in
            self?.viewModel.longPressReleased()
            self?.lottieView.isHidden = true
            self?.timerComponent.isHidden = true
        }

        $0.onButtonTapped = tapHandler
        return $0
    }(RecordingButton())

    private lazy var tooltip: Tooltip = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alpha = 0
        return $0
    }(Tooltip(text: MindsSDKConfigs.shared.voiceRecordingButtonInstruction()))

    private lazy var footerView: VoiceRecordFooterView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(VoiceRecordFooterView(versionNumber: Version.versionCode))

    private let viewModel: VoiceRecordViewModel

    init(viewModel: VoiceRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func tapHandler() {
        UIView.animate(withDuration: 1, delay: 0) { [weak self] in
            self?.tooltip.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            UIView.animate(withDuration: 1, delay: 0) {
                self?.tooltip.alpha = 0
            }
        }
    }
    
}

extension VoiceRecordView: ViewConfiguration {

    func configureViews() {
        backgroundColor = .white
    }

    func setupViewHierarchy() {
        addSubview(headerTitleLabel)
        addSubview(headerSubtitleLabel)
        addSubview(voiceRecordLabel)
        addSubview(lottieView)
        addSubview(timerComponent)
        addSubview(tooltip)
        addSubview(recordVoiceButton)
        addSubview(footerView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Layout.verticalPadding.rawValue),
            headerTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.horizontalPadding.rawValue),
            headerTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.horizontalPadding.rawValue)
        ])

        NSLayoutConstraint.activate([
            headerSubtitleLabel.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor),
            headerSubtitleLabel.leadingAnchor.constraint(equalTo: headerTitleLabel.leadingAnchor),
            headerSubtitleLabel.trailingAnchor.constraint(equalTo: headerTitleLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            voiceRecordLabel.topAnchor.constraint(equalTo: headerSubtitleLabel.bottomAnchor, constant: Layout.voiceRecordTopAnchor.rawValue),
            voiceRecordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.horizontalPadding.rawValue),
            voiceRecordLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.horizontalPadding.rawValue),
            voiceRecordLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5)
        ])

        NSLayoutConstraint.activate([
            lottieView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.horizontalPadding.rawValue),
            lottieView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.horizontalPadding.rawValue),
            lottieView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1),
            lottieView.bottomAnchor.constraint(equalTo: timerComponent.topAnchor)
        ])

        NSLayoutConstraint.activate([
            timerComponent.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.horizontalPadding.rawValue),
            timerComponent.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.horizontalPadding.rawValue),
            timerComponent.bottomAnchor.constraint(equalTo: recordVoiceButton.topAnchor, constant: -Layout.topAnchorFromRecordButton.rawValue)
        ])
        
        NSLayoutConstraint.activate([
            tooltip.widthAnchor.constraint(equalToConstant: Layout.tooltipWidth.rawValue),
            tooltip.heightAnchor.constraint(equalToConstant: Layout.tooltipHeight.rawValue),
            tooltip.centerXAnchor.constraint(equalTo: centerXAnchor),
            tooltip.bottomAnchor.constraint(equalTo: recordVoiceButton.topAnchor, constant: -Layout.topAnchorFromRecordButton.rawValue)
        ])

        NSLayoutConstraint.activate([
            recordVoiceButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            recordVoiceButton.heightAnchor.constraint(equalToConstant: RecordingButton.RecordingButtonSizes.regular.rawValue),
            recordVoiceButton.widthAnchor.constraint(equalToConstant: RecordingButton.RecordingButtonSizes.regular.rawValue),
            recordVoiceButton.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -Layout.voiceRecordBottomAnchor.rawValue)
        ])

        NSLayoutConstraint.activate([
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Layout.footerViewBottomAnchor.rawValue),
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.08)
        ])
    }
    
}
