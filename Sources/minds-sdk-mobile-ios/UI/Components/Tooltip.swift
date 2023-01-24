//
//  Tooltip.swift
//  
//
//  Created by Guilherme Domingues on 24/01/23.
//

import Foundation
import UIKit

final class Tooltip: UIView {

    private lazy var textLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = text
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 12, weight: .light)
        $0.numberOfLines = 0
       return $0
    }(UILabel())
    
    let text: String

    init(text: String) {
        self.text = text
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension Tooltip: ViewConfiguration {

    func configureViews() {
        backgroundColor = .baselinePrimary
        layer.cornerRadius = 12
    }
    
    func setupViewHierarchy() {
        addSubview(textLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
