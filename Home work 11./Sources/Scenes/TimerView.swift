//
//  ViewController.swift
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
        
    }
    
    private func setupLayout() {
        labelTimer.translatesAutoresizingMaskIntoConstraints = false
        labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelTimer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        
    }
    
    private func setupView() {
        
        
    }

}

