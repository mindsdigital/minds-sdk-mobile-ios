//
//  RecordingButton.swift
//  
//
//  Created by Guilherme Domingues on 17/01/23.
//

import UIKit

final class RecordingButton: UIButton {

    enum RecordingButtonSizes: CGFloat {
        case regular = 60
    }
    
    #if SWIFT_PACKAGE
    let resourceBundle = Bundle.module
    #else
    let resourceBundle = MindsSDKBundle.resourceBundle
    #endif

    private lazy var microphoneIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "voice", in: resourceBundle, compatibleWith: nil)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var onButtonTapped: (() -> Void)?
    var onLongPressStart: (() -> Void)?
    var onLongPressEnd: (() -> Void)?
    
    private let size: RecordingButtonSizes
    private let minimumPressDuration: CGFloat
    private let feedbackGenerator: UIImpactFeedbackGenerator

    init(size: RecordingButtonSizes = .regular, minimumPressDuration: CGFloat = 0.5,
         feedbackGenerator: UIImpactFeedbackGenerator = .init()) {
        self.size = size
        self.minimumPressDuration = minimumPressDuration
        self.feedbackGenerator = feedbackGenerator
        super.init(frame: .zero)
        setupViews()
        setupGestures()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGestures() {
        setLongPressGesture()
        setTapGesture()
    }

    private func setTapGesture() {
        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGesture)
    }

    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            onLongPressStart?()
            applyScale(isIdentity: false)
            feedbackGenerator.impactOccurred()
        case .ended, .cancelled:
            onLongPressEnd?()
            applyScale(isIdentity: true)
        default:
            _ = 0
        }
    }

    private func setLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer = .init(target: self, action: #selector(handleLongPress(gesture:)))
        longPressGesture.minimumPressDuration = minimumPressDuration
        addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleTapGesture() {
        onButtonTapped?()
    }

    private func applyScale(isIdentity: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0) { [weak self] in
            if isIdentity {
                self?.transform = .identity
            } else {
                self?.transform = .init(scaleX: 1.25, y: 1.25)
            }
        }
    }

}

extension RecordingButton: ViewConfiguration {

    func configureViews() {
        backgroundColor = MindsSDKConfigs.shared.voiceRecordingButtonColor()
        clipsToBounds = true
        layer.cornerRadius = size.rawValue * 0.5
    }
    
    func setupViewHierarchy() {
        addSubview(microphoneIconImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            microphoneIconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            microphoneIconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            microphoneIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            microphoneIconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }

}
