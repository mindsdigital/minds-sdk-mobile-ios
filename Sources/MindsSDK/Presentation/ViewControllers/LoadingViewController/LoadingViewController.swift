//
//  LoadingViewController.swift
//  
//
//  Created by Guilherme Domingues on 25/01/23.
//

import UIKit

final class LoadingViewController: UIViewController {
    
    let loadingView: LoadingView
    

    init() {
        self.loadingView = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = loadingView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        loadingView.viewDidAppear()
    }

}
