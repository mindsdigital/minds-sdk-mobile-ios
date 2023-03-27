//
//  LoadingView.swift
//  
//
//  Created by Guilherme Domingues on 25/01/23.
//

import UIKit
import Lottie

final class LoadingView: UIView {
    
    private lazy var lottieView: AnimationView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let animation = Animation.named(LottieAnimations.loadingLottieAnimation, bundle: Bundle.module)
        let keypath = AnimationKeypath(keypath: "Shape Layer 1.Ellipse 1.Stroke 1.Color")
        $0.animation = animation
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        if let (red, green, blue) = UIColor.hexToRGB(MindsSDKConfigs.shared.loadingLootieAnimationColor()) {
            let colorProvider = ColorValueProvider(Color(r: (Double(red)/255), g: (Double(green)/255), b: (Double(blue)/255), a: 1))
            $0.setValueProvider(colorProvider, keypath: keypath)
        } else {
            debugPrint("Invalid hex string")
        }
        $0.logHierarchyKeypaths()
        $0.play()
        return $0
    }(AnimationView(frame: .zero))

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func viewDidAppear() {
        lottieView.play()
    }

}

extension LoadingView: ViewConfiguration {

    func configureViews() {
        backgroundColor = .white
    }
    
    func setupViewHierarchy() {
        addSubview(lottieView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            lottieView.centerXAnchor.constraint(equalTo: centerXAnchor),
            lottieView.centerYAnchor.constraint(equalTo: centerYAnchor),
            lottieView.widthAnchor.constraint(equalToConstant: 80),
            lottieView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

}
