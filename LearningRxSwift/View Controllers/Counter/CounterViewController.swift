//
//  CounterViewController.swift
//  LearningRxSwift
//
//  Created by Ademola Fadumo on 24/11/2023.
//

import UIKit
import RxSwift
import RxRelay

class CounterViewController: UIViewController {

    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let counterText: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.setImage(
            .add.applyingSymbolConfiguration(
                .init(pointSize: 44)
            ),
            for: .normal
        )
        button.addAction(
            UIAction(handler: {
                [weak self] _ in
                self?.increment()
            }),
            for: .primaryActionTriggered
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.setImage(
            .remove.applyingSymbolConfiguration(
                .init(pointSize: 44)
            ),
            for: .normal
        )
        button.addAction(
            UIAction(handler: {
                [weak self] _ in
                self?.decrement()
            }),
            for: .primaryActionTriggered
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let bag = DisposeBag()
    
    private let counterRelay = BehaviorRelay<Int>(value: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        initializeSubviews()
        initializeCounterSubscription()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyConstraints()
    }
    
    private func initializeSubviews() {
        view.addSubview(mainView)
        mainView.addSubview(counterText)
        mainView.addSubview(incrementButton)
        mainView.addSubview(decrementButton)
    }

    private func initializeCounterSubscription() {
        counterRelay.subscribe(
            onNext: {[weak self] value in
                self?.counterText.text = String(value)
            },
            onError: { error in
                print(error)
            },
            onDisposed: {
                // NOTE: this won't be called until app is terminated because it's the root view controller
                print("disposed")
            }
        ).disposed(by: bag)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // Main View constraints
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            // Counter Label constraints
            counterText.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            counterText.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            
            // Increment button constraints
            incrementButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            incrementButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            
            // Decrement button constraints
            decrementButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            decrementButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
    }
    
    private func increment() {
        counterRelay.accept(counterRelay.value + 1)
    }
    
    private func decrement() {
        counterRelay.accept(counterRelay.value - 1)
    }
}

