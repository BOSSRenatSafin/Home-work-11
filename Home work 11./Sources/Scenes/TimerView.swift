//
//  TimerView.swift
//  Home work 11.
//
//  Created by Ренат Сафин on 20.12.2021.
//

import UIKit

class TimerView: UIViewController {
    
    private lazy var labelTimer: UILabel = {
       var labelTimer = UILabel()
        labelTimer.text = "00:10"
        labelTimer.textColor = .red
        labelTimer.font = .systemFont(ofSize: 80)
        labelTimer.sizeToFit()
        return labelTimer
    }()
    
    private lazy var button: UIButton = {
        var button = UIButton()
        let configurationImage = UIImage.SymbolConfiguration(pointSize: 60)
        let imageButton = UIImage(systemName: "play", withConfiguration: configurationImage)
        button.setImage(imageButton, for: .normal)
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()

    private var timer = Timer()
    private var durationTimer = 10 {
        didSet {
            labelTimer.text = durationTimer < 10 ? "00:0\(durationTimer)" : "00:\(durationTimer)"
        }
    }
    private var isStarted = false
    private var isWorkTime = true
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupHierarchy()
        setupLayout()
        setupView()
    }

    //MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(labelTimer)
        view.addSubview(button)
    }
    
    private func setupLayout() {
        labelTimer.translatesAutoresizingMaskIntoConstraints = false
        labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelTimer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
    }
    
    private func setupView() {
        
        
    }

    //MARK: - Actions
    
    @objc private func timerAction() {
        guard durationTimer > 0 else {
            isStarted = !isStarted
            isWorkTime = !isWorkTime
            timer.invalidate()
            return
        }
        durationTimer -= 1
    }
    
    @objc private func buttonAction() {
        isStarted = !isStarted
        
        if isStarted {
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self, selector: #selector(timerAction),
                                         userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
        }
    }
    
}

