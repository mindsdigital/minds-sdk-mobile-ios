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

    let viewModel: VoiceRecordViewModel

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
    
    private func setupViews() {
        addSubview(voiceRecordLabel)

        NSLayoutConstraint.activate([
            voiceRecordLabel.topAnchor.constraint(equalTo: topAnchor),
            voiceRecordLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            voiceRecordLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            voiceRecordLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
