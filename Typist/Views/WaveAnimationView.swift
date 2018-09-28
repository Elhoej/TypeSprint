//
//  WaveAnimationView.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 25/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class WaveAnimationView: UIView, CAAnimationDelegate
{
    private var timer: Timer?
    private var labelTimer: Timer?
    private let alphabet = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "a", "s", "d", "f", "g", "h",  "j", "k", "l", "z", "x", "c", "v", "b", "n", "m"]
    
    private var pathArray = [UIBezierPath]()
    
    let countLabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.sizeToFit()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = .clear
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCountLabel)))
        
        addSubview(countLabel)
        countLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 250).isActive = true
    }
    
    private var labelCounter = 0
    
    func stopAnimation()
    {
        timer?.invalidate()
    }
    
    @objc private func showCountLabel()
    {
        labelTimer?.invalidate()
        labelCounter += 1
        countLabel.text = "+\(labelCounter)"
        labelTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(removeLabelAndAnimate), userInfo: nil, repeats: false)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.countLabel.alpha = 1
            self.countLabel.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.3)
            
        }) { (completed) in
            
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                
                self.countLabel.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
                
            }, completion: nil)
        }
    }
    
    @objc private func removeLabelAndAnimate()
    {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.countLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
            self.countLabel.alpha = 0
            
        }) { (completed) in
            
            self.labelCounter = 0
        }
        
        for _ in 0...labelCounter
        {
            addNewDot()
        }
    }
    
    func startAnimation()
    {
        addNewDot()
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(addNewDot), userInfo: nil, repeats: true)
    }
    
    private let animationStyles = [CAMediaTimingFunctionName.easeInEaseOut, CAMediaTimingFunctionName.easeOut, CAMediaTimingFunctionName.easeIn, CAMediaTimingFunctionName.linear]
    
    var dotArray = [UILabel]()
    
    @objc func addNewDot()
    {
        let letter = UILabel(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        letter.text = alphabet[Int.random(in: 0...25)]
        letter.font = UIFont.systemFont(ofSize: 11)
        letter.textAlignment = .center
        letter.backgroundColor = .clear
        letter.textColor = .white
        
        let randomNumForPath = generateRandomNumber(min: 0, max: 39)
        let randomNumForDuration = generateRandomNumber(min: 6, max: 15)
        let randomNumForAnimationStyle = generateRandomNumber(min: 0, max: 3)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = self.pathArray[randomNumForPath].cgPath
        animation.duration = CFTimeInterval(randomNumForDuration)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: animationStyles[randomNumForAnimationStyle])
        animation.delegate = self
        letter.layer.add(animation, forKey: nil)
        
        self.addSubview(letter)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        if flag
        {
            //iuhe
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        var incrementingY = 5
        var incrementingCurvePoint = 4
        
        for index in 1...40
        {
            let startAndEndY = Int(self.bounds.maxY) - (incrementingY + index)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: Int(self.bounds.maxX) + 10, y: startAndEndY))
            
            let curvePointOne = CGPoint(x: 100, y: startAndEndY - incrementingCurvePoint)
            let curvePointTwo = CGPoint(x: 200, y: startAndEndY + incrementingCurvePoint)
            
            path.addCurve(to: CGPoint(x: -10, y: startAndEndY), controlPoint1: curvePointTwo, controlPoint2: curvePointOne)
            
            path.lineWidth = 0.5
            UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).setStroke()
            path.stroke(with: CGBlendMode.color, alpha: 0.3)
            
            self.pathArray.append(path)
            incrementingY += 5
            incrementingCurvePoint += 3
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
