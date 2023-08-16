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
        let animationView = AnimationView(frame: .zero)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        let animationName = LottieAnimations.loadingLottieAnimation

        #if SWIFT_PACKAGE
        let resourceBundle = Bundle.module
        #else
        let resourceBundle = MindsSDKBundle.resourceBundle
        #endif
        
        if let animation = Animation.named(animationName, bundle: resourceBundle) {
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            
            if let (red, green, blue) = UIColor.hexToRGB(MindsSDKConfigs.shared.loadingLootieAnimationColor()) {
                let colorProvider = ColorValueProvider(Color(r: Double(red) / 255, g: Double(green) / 255, b: Double(blue) / 255, a: 1))
                let keypath = AnimationKeypath(keypath: "Shape Layer 1.Ellipse 1.Stroke 1.Color")
                animationView.setValueProvider(colorProvider, keypath: keypath)
            } else {
                debugPrint("Invalid hex string")
            }
            
            animationView.play()
        } else {
            debugPrint("Failed to load animation: \(animationName)")
        }
        
        return animationView
    }()


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
