//
//  ViewController.swift
//  MyAnimationCircle
//
//  Created by 黎峻亦 on 2018/6/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let pulsatingLayer = CAShapeLayer()
    var timer : Timer?
    var count = 0
    var isRun = false
    let circularPath = UIBezierPath(arcCenter: .zero,
                                    radius: 70,
                                    startAngle: 0,
                                    endAngle: 2 * CGFloat.pi,
                                    clockwise: true)
    
    
    let percentageLabel : UILabel = {
        let label = UILabel()
        label.text = "Ready"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backGroundColor
        
        setLayer(layer: pulsatingLayer, strokeColor: .clear, strokeEnd: 1, fillColor: .pulsatingFillColor)
        setLayer(layer: trackLayer, strokeColor: .trackStrokeColor, strokeEnd: 1, fillColor: .backGroundColor)
        setLayer(layer: shapeLayer, strokeColor: .outlineStrokeColor, strokeEnd: 0, fillColor: .clear)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        pulsatingAnimation()
        setUpNotificationbservers()
        setPercentageLabel()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func setUpNotificationbservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc
    func handleEnterForeground(){
        pulsatingAnimation()
    }
    
    private func setPercentageLabel(){
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        percentageLabel.textColor = .white
    }
    
    private func pulsatingAnimation(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    private func setLayer(layer : CAShapeLayer,strokeColor : UIColor,strokeEnd : CGFloat,fillColor : UIColor){
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 15
        layer.position = view.center
        layer.strokeEnd = strokeEnd
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        view.layer.addSublayer(layer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadingAnimate()
    }
    
    @objc
    private func handleTap(){
        loadingAnimate()
    }
    
    private func loadingAnimate(){
        guard !isRun else {
            return
        }
        isRun = true
        count = 0
        shapeLayer.strokeEnd = 0
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc
    func updateTimer(){
        let strokeEnd = Double(count) * 0.1
        shapeLayer.strokeEnd = CGFloat(strokeEnd)
        percentageLabel.text = "\(count * 10)"
        if count >= 10 {
            isRun = false
            timer?.invalidate()
            timer = nil
        }else{
            count += 1
        }
    }

}

