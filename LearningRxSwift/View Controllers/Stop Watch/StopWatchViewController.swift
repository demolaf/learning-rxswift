//
//  StopWatchViewController.swift
//  LearningRxSwift
//
//  Created by Ademola Fadumo on 27/11/2023.
//

import UIKit

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
            }),
            for: .primaryActionTriggered
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        initializeSubviews()
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
        ])
    }
}
