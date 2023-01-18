//
//  VoiceRecordView.swift
//  
//
//  Created by Guilherme Domingues on 11/01/23.
//

import UIKit

final class VoiceRecordView: UIView {

    private enum Layout: CGFloat {
        case horizontalPadding = 24
        case verticalPadding = 48
    }
    
    private lazy var headerTitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = MindsSDKConfigs.shared.voiceRecordingTitle()
        $0.textColor = MindsSDKConfigs.shared.voiceRecordTitleColor()
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        return $0
    }(UILabel())

    private lazy var headerSubtitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = MindsSDKConfigs.shared.voiceRecordingSubtitle()
        $0.textColor = MindsSDKConfigs.shared.voiceRecordSubtitleColor()
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 12, weight: .light)
        return $0
    }(UILabel())

    private lazy var voiceRecordLabel: UILabel = {
        $0.text = viewModel.livenessText.result
        $0.textColor = MindsSDKConfigs.shared.voiceRecordMainTextColor()
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 30, weight: .regular)
        return $0
    }(UILabel())

    private lazy var recordVoiceButton: RecordingButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.onLongPressStart = viewModel.startRecording
        $0.onLongPressEnd = viewModel.stopRecording
        $0.onButtonTapped = tapHandler
        return $0
    }(RecordingButton())

    private lazy var footerView: VoiceRecordFooterView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(VoiceRecordFooterView(versionNumber: Version.versionCode))

    let viewModel: VoiceRecordViewModel
    
    var isRecording: Bool = false

    init(viewModel: VoiceRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        backgroundColor = .white
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func tapHandler() {
        
    }
    
}

extension VoiceRecordView: ViewConfiguration {

    func configureViews() { }

    func setupViewHierarchy() {
        addSubview(headerTitleLabel)
        addSubview(headerSubtitleLabel)
        addSubview(voiceRecordLabel)
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
            voiceRecordLabel.topAnchor.constraint(equalTo: headerSubtitleLabel.bottomAnchor, constant: 100),
            voiceRecordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.horizontalPadding.rawValue),
            voiceRecordLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.horizontalPadding.rawValue),
            voiceRecordLabel.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            recordVoiceButton.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -48),
            recordVoiceButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            recordVoiceButton.heightAnchor.constraint(equalToConstant: RecordingButton.RecordingButtonSizes.regular.rawValue),
            recordVoiceButton.widthAnchor.constraint(equalToConstant: RecordingButton.RecordingButtonSizes.regular.rawValue)
        ])

        NSLayoutConstraint.activate([
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1)
        ])
    }
    
}
