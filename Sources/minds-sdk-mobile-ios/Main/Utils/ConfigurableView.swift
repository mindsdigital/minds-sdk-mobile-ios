//
//  ConfigurableView.swift
//  
//
//  Created by Guilherme Domingues on 17/01/23.
//

import UIKit

protocol ViewConfiguration: AnyObject {
    func setupViews()
    func configureViews()
    func setupViewHierarchy()
    func setupConstraints()
}

extension ViewConfiguration {

    func setupViews() {
        configureViews()
        setupViewHierarchy()
        setupConstraints()
    }

}
