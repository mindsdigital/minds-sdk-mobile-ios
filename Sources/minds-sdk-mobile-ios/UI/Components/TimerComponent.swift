//
//  TimerComponent.swift
//  
//
//  Created by Guilherme Domingues on 19/01/23.
//

import UIKit
import Lottie

protocol TimerComponentViewModelDelegate: AnyObject {
    func updateTo(newValue: Int)
}

final class TimerComponentViewModel {
    
    weak var delegate: TimerComponentViewModelDelegate?
    
    var timerTicksWhenInvalidated: ((Int) -> Void)?
    
    private var timer: Timer?
    private var timerTicks: Int = 0
    private let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval = 1.0) {
        self.timeInterval = timeInterval
    }
    
    func startTicking() {
        timer = .scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(handleTimerTick), userInfo: nil, repeats: true)
    }

    func invalidateTimer() {
        timerTicksWhenInvalidated?(timerTicks)
        timerTicks = 0
        timer?.invalidate()
    }

    @objc private func handleTimerTick() {
        timerTicks += 1
        delegate?.updateTo(newValue: timerTicks)
    }

}

final class TimerComponent: UIView {

    private lazy var timerLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        return $0
    }(UILabel())

    private var viewModel: TimerComponentViewModel
    
    init(viewModel: TimerComponentViewModel) {
        self.viewModel = viewModel

        super.init(frame: .zero)
        setupViews()
        viewModel.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func maskTimer(value counter: Int) -> String {
        let seconds = String(format: "%.2d", counter % 60)
        let minutes = String(format: "%.2d", (counter / 60) % 60)
        return "\(minutes):\(seconds)"
    }

}

extension TimerComponent: TimerComponentViewModelDelegate {

    func updateTo(newValue: Int) {
        let maskedTimer: String = maskTimer(value: newValue)
        timerLabel.text = maskedTimer
    }

}

extension TimerComponent: ViewConfiguration {

    func configureViews() { }
    
    func setupViewHierarchy() {
        addSubview(timerLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: topAnchor),
            timerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            timerLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
