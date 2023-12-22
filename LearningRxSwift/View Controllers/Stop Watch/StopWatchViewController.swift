//
//  StopWatchViewController.swift
//  LearningRxSwift
//
//  Created by Ademola Fadumo on 27/11/2023.
//

import UIKit
import RxSwift
import RxRelay

enum StopWatchState {
    case running
    case paused
    case stopped
}

class StopWatchViewController: UIViewController {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stopWatch: StopWatch = {
        let stopWatch = StopWatch()
        stopWatch.translatesAutoresizingMaskIntoConstraints = false
        return stopWatch
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("Reset", for: .normal)
        button.configuration?.background.backgroundColor = .systemRed
        button.addAction(
            UIAction(handler: {
                [weak self] _ in
                self?.resetButtonPressed()
            }),
            for: .primaryActionTriggered
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var pauseOrResumeButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("Pause", for: .normal)
        button.configuration?.background.backgroundColor = .blue
        button.addAction(
            UIAction(handler: {
                [weak self] _ in
                self?.pauseOrResumeButtonPressed()
            }),
            for: .primaryActionTriggered
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("Start", for: .normal)
        button.configuration?.background.backgroundColor = .systemGreen
        button.addAction(
            UIAction(handler: {
                [weak self] _ in
                self?.startButtonPressed()
            }),
            for: .primaryActionTriggered
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var timer: Timer?
    
    private let disposeBag = DisposeBag()
    
    private let stopWatchRelay = BehaviorRelay<TimeInterval>(value: 0)
    
    private let stopWatchStateRelay = BehaviorRelay<StopWatchState>(value: .stopped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        initializeSubviews()
        initializeStopwatchSubscription()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyConstraints()
    }
    
    private func initializeSubviews() {
        view.addSubview(mainView)
        mainView.addSubview(stopWatch)
        mainView.addSubview(resetButton)
        mainView.addSubview(startButton)
        mainView.addSubview(pauseOrResumeButton)
    }
    
    private func initializeStopwatchSubscription() {
        stopWatchRelay
            .map(formatSecondsToTimerString)
            .subscribe(onNext: { [weak self] value in
                self?.stopWatch.timerTextLabel.text = String(value)
            })
            .disposed(by: disposeBag)
        
        stopWatchStateRelay
            .debug("stop watch state")
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .running:
                    self?.startButton.isHidden = true
                    self?.resetButton.isHidden = false
                    self?.pauseOrResumeButton.isHidden = false
                    self?.pauseOrResumeButton.setTitle("Pause", for: .normal)
                case .paused:
                    self?.pauseOrResumeButton.setTitle("Resume", for: .normal)
                case .stopped:
                    self?.startButton.isHidden = false
                    self?.resetButton.isHidden = true
                    self?.pauseOrResumeButton.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // Main View constraints
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            // Counter Label constraints
            stopWatch.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            stopWatch.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            
            // Increment button constraints
            resetButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            resetButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Decrement button constraints
            startButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            startButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Pause or Resume button constraints
            pauseOrResumeButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            pauseOrResumeButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            pauseOrResumeButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func resetButtonPressed() {
        self.timer?.invalidate()
        self.timer = nil
        self.stopWatchRelay.accept(0)
        self.stopWatchStateRelay.accept(.stopped)
    }
    
    private func pauseOrResumeButtonPressed() {
        switch stopWatchStateRelay.value {
        case .running:
            self.timer?.invalidate()
            self.stopWatchStateRelay.accept(.paused)
        case .paused:
            self.createTimer()
            self.stopWatchStateRelay.accept(.running)
        default:
            debugPrint("Do nothing")
        }
    }
    
    private func startButtonPressed() {
        self.createTimer()
        self.timer?.fire()
        self.stopWatchStateRelay.accept(.running)
    }
    
    private func createTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            self?.stopWatchRelay.accept((self?.stopWatchRelay.value ?? 0) + 1)
        }
    }
    
    private func formatSecondsToTimerString(seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour, .minute, .second]
        
        return formatter.string(from: seconds) ?? "00:00:00"
    }
}
