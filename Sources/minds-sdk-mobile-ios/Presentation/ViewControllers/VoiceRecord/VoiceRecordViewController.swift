//
//  VoiceRecordViewController.swift
//  
//
//  Created by Guilherme Domingues on 11/01/23.
//

import UIKit

protocol VoiceRecordViewControllerDelegate: AnyObject {
    func closeFlow()
}

final class VoiceRecordViewController: UIViewController {
    
    private let viewModel: VoiceRecordViewModel
    private let voiceRecordView: VoiceRecordView
    weak var delegate: VoiceRecordViewControllerDelegate?

    init(viewModel: VoiceRecordViewModel) {
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
        view = voiceRecordView
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
        delegate?.closeFlow()
    }
    
}

