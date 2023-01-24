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

    private var stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = -34
        $0.distribution = .fillEqually
        $0.alignment = .center
        return $0
    }(UIStackView())

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
        addSubview(stackView)
        stackView.addArrangedSubview(signatureLabel)
        stackView.addArrangedSubview(versionNumberLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
