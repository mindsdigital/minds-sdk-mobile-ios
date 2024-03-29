//
//  MainCoordinator.swift
//  
//
//  Created by Guilherme Domingues on 25/01/23.
//

import Foundation
import UIKit

final class MainCoordinator {
    
    private let navigationController: UINavigationController
    private let loadingViewController: LoadingViewController = .init()
    private var voiceRecordViewController: VoiceRecordViewController?
    let allowBackAction: Bool = SDKDataRepository.shared.allowBackAction
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showVoiceRecordView(delegate: MindsSDKDelegate?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let voiceRecordViewController: UIViewController = self.createVoiceRecordViewController(delegate)
            self.hideBackButton(voiceRecordViewController)
            self.navigationController.pushViewController(voiceRecordViewController, animated: true)
        }
    }

    private func createVoiceRecordViewController(_ delegate: MindsSDKDelegate?) -> UIViewController {
        let viewModel: VoiceRecordViewModel = .init(livenessText: SDKDataRepository.shared.liveness)
        viewModel.mindsDelegate = delegate
        voiceRecordViewController = .init(viewModel: viewModel, delegate: self)

        return voiceRecordViewController ?? UIViewController(nibName: nil, bundle: nil)
    }
    
    private func hideBackButton(_ controller: UIViewController) {
        if (!allowBackAction) {
            controller.navigationItem.setHidesBackButton(true, animated: false)
        }
    }

}

extension MainCoordinator: VoiceRecordViewControllerDelegate {

    func closeFlow() {
        hideLoading()

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.navigationController.popToRootViewController(animated: true)
        }
    }

    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.navigationController.pushViewController(self.loadingViewController, animated: false)
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let voiceRecordViewController = self?.voiceRecordViewController,
                  let navigationController = self?.navigationController,
                  navigationController.viewControllers.contains(voiceRecordViewController) else {
                return
            }
            
            navigationController.popToViewController(voiceRecordViewController, animated: false)
        }
    }
}
