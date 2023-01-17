//
//  VoiceRecordViewController.swift
//  
//
//  Created by Guilherme Domingues on 11/01/23.
//

import UIKit

final class VoiceRecordViewController: UIViewController {
    
    private let viewModel: VoiceRecordViewModel
    private let voiceRecordView: VoiceRecordView
    
    init(viewModel: VoiceRecordViewModel) {
        self.viewModel = viewModel
        self.voiceRecordView = .init(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = voiceRecordView
    }

}
