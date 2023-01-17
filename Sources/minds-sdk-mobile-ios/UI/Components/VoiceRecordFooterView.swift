//
//  VoiceRecordFooterView.swift
//  
//
//  Created by Guilherme Domingues on 17/01/23.
//

import UIKit

final class VoiceRecordFooterView: UIView {
    
    private lazy var signatureLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.text = "Minds Digital"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 10, weight: .light)
        return $0
    }(UILabel())

    private lazy var versionNumberLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.text = "Versão \(versionNumber)"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 10, weight: .light)
        return $0
    }(UILabel())

    private let versionNumber: String

    init(versionNumber: String) {
        self.versionNumber = versionNumber
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension VoiceRecordFooterView: ViewConfiguration {

    func configureViews() { }
    
    func setupViewHierarchy() {
        addSubview(signatureLabel)
        addSubview(versionNumberLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            signatureLabel.topAnchor.constraint(equalTo: topAnchor),
            signatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            signatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            versionNumberLabel.topAnchor.constraint(equalTo: signatureLabel.bottomAnchor, constant: 1),
            versionNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            versionNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
}
