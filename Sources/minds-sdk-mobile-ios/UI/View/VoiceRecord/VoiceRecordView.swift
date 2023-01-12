//
//  VoiceRecordView.swift
//  
//
//  Created by Guilherme Domingues on 11/01/23.
//

import UIKit

final class VoiceRecordView: UIView {
    
    lazy var voiceRecordLabel: UILabel = {
        $0.text = viewModel.livenessText.result
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    lazy var recordVoiceButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Record Voice", for: .normal)
        $0.addTarget(self, action: #selector(handleVoiceRecordButton), for: .touchDown)
        $0.backgroundColor = .lightGray
        return $0
    }(UIButton(frame: .zero))

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
    
    @objc func handleVoiceRecordButton() {
        if !isRecording {
            viewModel.startRecording()
            isRecording = true
        } else {
            viewModel.stopRecording()
            isRecording = false
        }
    }
    
}

extension VoiceRecordView {

    func setupViews() {
        configureViewHierarchy()
        setupConstraints()
    }

    func configureViewHierarchy() {
        addSubview(voiceRecordLabel)
        addSubview(recordVoiceButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            voiceRecordLabel.topAnchor.constraint(equalTo: topAnchor),
            voiceRecordLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            voiceRecordLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            voiceRecordLabel.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            recordVoiceButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -150),
            recordVoiceButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            recordVoiceButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
