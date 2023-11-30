//
//  StopWatch.swift
//  LearningRxSwift
//
//  Created by Ademola Fadumo on 28/11/2023.
//

import UIKit

class StopWatch: UIView {
    
    private let size: CGSize
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = size.width * 0.5
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 4
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timerText: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = .systemFont(ofSize: 28)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(
        frame: CGRect = .zero,
        size: CGSize = CGSize(width: 200, height: 200)
    ) {
        self.size = size
        super.init(frame: frame)
        initializeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyConstraints()
    }
    
    private func initializeSubviews() {
        self.addSubview(mainView)
        mainView.addSubview(circleView)
        circleView.addSubview(timerText)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // mainView constraints
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // circleView constraints
            circleView.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor),
            circleView.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor),
            circleView.topAnchor.constraint(equalTo: self.mainView.topAnchor),
            circleView.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor),
            circleView.widthAnchor.constraint(equalToConstant: size.width),
            circleView.heightAnchor.constraint(equalToConstant: size.height),
            
            // timerText constraints
            timerText.centerXAnchor.constraint(equalTo: self.circleView.centerXAnchor),
            timerText.centerYAnchor.constraint(equalTo: self.circleView.centerYAnchor),
        ])
    }
}
