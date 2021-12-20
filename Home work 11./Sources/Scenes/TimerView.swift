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
        labelTimer.text = String(format: "%02i:%02i", Metric.minutes, Metric.seconds)
        labelTimer.textColor = isWorkTime ? Color.workState : Color.relaxState
        labelTimer.font = .systemFont(ofSize: Metric.labelSize)
        labelTimer.sizeToFit()
        return labelTimer
    }()
    
    private lazy var button: UIButton = {
        var button = UIButton()
        let currentColor = isWorkTime ? Color.workState : Color.relaxState
        let configurationImage = UIImage.SymbolConfiguration(pointSize: Metric.buttonSize)
        button.setPreferredSymbolConfiguration(configurationImage, forImageIn: .normal)
        button.setImage(Icon.start?.withTintColor(currentColor, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(Icon.pause?.withTintColor(currentColor, renderingMode: .alwaysOriginal), for: .selected)
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }()
    
    private var timer = Timer()
    private var durationTimer = Metric.workTimeValue {
        didSet {
            labelTimer.text = durationTimer < Metric.workTimeValue ? "00:0\(durationTimer)" : "00:\(durationTimer)"
        }
    }
    private var isStarted = false {
        didSet {
            button.isSelected = isStarted
        }
    }
    private var isWorkTime = true {
        didSet {
            durationTimer = isWorkTime ? Metric.workTimeValue : Metric.relaxTimeValue
            labelTimer.textColor = isWorkTime ? Color.workState : Color.relaxState
            let currentColor = isWorkTime ? Color.workState : Color.relaxState
            button.setImage(Icon.start?.withTintColor(currentColor, renderingMode: .alwaysOriginal), for: .normal)
            button.setImage(Icon.pause?.withTintColor(currentColor, renderingMode: .alwaysOriginal), for: .selected)
        }
    }
    
    private lazy var shapeLayer = CAShapeLayer()
    private lazy var trackLayer = CAShapeLayer()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createCircleAnimation()
        setCircleColor()
    }
    
    //MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(labelTimer)
        view.addSubview(button)
        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(shapeLayer)
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
    
    private func createCircleAnimation() {
        let center = view.center
        let radius = min(view.frame.width, view.frame.height) / 2.2
        let startAngle = 3 / 2 * CGFloat.pi
        let endAngle = startAngle - (2 * CGFloat.pi)
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: false)
        trackLayer.path = circlePath.cgPath
        trackLayer.strokeColor = Color.workState.cgColor
        trackLayer.lineWidth = Metric.widthCircle
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = Color.workState.cgColor
        shapeLayer.lineWidth = Metric.widthCircle
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 1
    }
    
    private func startAnimationCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.speed = 1.0
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAniation")
    }
    
    func setCircleColor() {
        let currentColorTrack = isWorkTime ? Color.workTrackLayer : Color.relaxTrackLayer
        let currentColorShape = isWorkTime ? Color.workShapeLayer : Color.relaxShapeLayer
        trackLayer.strokeColor = currentColorTrack.cgColor
        shapeLayer.strokeColor = currentColorShape.cgColor
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
            startAnimationCircle()
        } else {
            timer.invalidate()
        }
    }
}

extension TimerView {
    enum Icon {
        static let start = UIImage(systemName: "play")
        static let pause = UIImage(systemName: "pause")
    }
    
    enum Metric {
        static let labelSize: CGFloat = 80
        static let buttonSize: CGFloat = 60
        static let workTimeValue = 10
        static let relaxTimeValue = 5
        static let minutes = workTimeValue / 60 % 60
        static let seconds = workTimeValue % 60
        static let widthCircle: CGFloat = 10
    }
    
    enum Color {
        static let workState = UIColor.systemRed
        static let relaxState = UIColor.systemGreen
        static let relaxTrackLayer = UIColor.systemGreen.withAlphaComponent(0.2)
        static let relaxShapeLayer = UIColor.systemGreen.withAlphaComponent(0.8)
        static let workTrackLayer = UIColor.systemRed.withAlphaComponent(0.2)
        static let workShapeLayer = UIColor.systemRed.withAlphaComponent(0.8)
    }
}



