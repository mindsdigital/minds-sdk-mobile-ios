//
//  RecordingButton.swift
//  
//
//  Created by Guilherme Domingues on 17/01/23.
//

import UIKit

final class RecordingButton: UIView {

    init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RecordingButton: ViewConfiguration {

    func configureViews() {
        backgroundColor = .red
        clipsToBounds = true
        layer.cornerRadius = 50
    }
    
    func setupViewHierarchy() {
        
    }
    
    func setupConstraints() {
        
    }

}
