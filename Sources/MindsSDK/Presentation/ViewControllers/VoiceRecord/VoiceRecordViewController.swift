//
//  VoiceRecordViewController.swift
//  
//
//  Created by Guilherme Domingues on 11/01/23.
//

import UIKit

protocol VoiceRecordViewControllerDelegate: AnyObject {
    func closeFlow()
    func showLoading()
    func hideLoading()
}

final class VoiceRecordViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let viewModel: VoiceRecordViewModel
    private let voiceRecordView: VoiceRecordView
    private let delegate: VoiceRecordViewControllerDelegate
    private var shouldContinueFlow: Bool = true
    private var isViewAppeared = false
    private var shouldDisablePopGesture = false
    

    init(viewModel: VoiceRecordViewModel, delegate: VoiceRecordViewControllerDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        self.voiceRecordView = .init(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = voiceRecordView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewAppeared = true
        updateInteractivePopGestureRecognizer()
    }
    
    private func updateInteractivePopGestureRecognizer() {
        guard let navigationController = navigationController else {
            return
        }

        if isViewAppeared && SDKDataRepository.shared.allowBackAction {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = self.navigationController {
            navigationController.interactivePopGestureRecognizer?.delegate = self
            navigationController.interactivePopGestureRecognizer?.addTarget(self, action: #selector(handleInteractivePopGesture(_:)))
        }
        
        updateInteractivePopGestureRecognizer()
    }
    
    @objc func handleInteractivePopGesture(_ gestureRecognizer: UIGestureRecognizer) {
        guard isViewAppeared else {
            return
        }
        
        if gestureRecognizer.state == .ended {
            if gestureRecognizer.location(in: view).x < 0 {
                viewModel.doBiometricsLater()
            }
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                return true
            }
        }
        return false
    }

}


extension VoiceRecordViewController: VoiceRecordViewModelDelegate {

    func showAlert(for errorType: VoiceRecordErrorType) {
        let alertView: UIAlertController = .init(title: errorType.title,
                                                 message: errorType.subtitle,
                                                 preferredStyle: .alert)
        let dismissAction: UIAlertAction = UIAlertAction(title: NSLocalizedString(errorType.dismissButtonLabel, comment: ""),
                                                         style: .default,
                                                         handler: { _ in })
        alertView.addAction(dismissAction)

        present(alertView, animated: true)
    }

    func closeFlow() {
        delegate.closeFlow()
    }

    func showLoading() {
        delegate.showLoading()
    }

    func hideLoading() {
        delegate.hideLoading()
    }
}
