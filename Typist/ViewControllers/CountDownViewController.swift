//
//  CountDownViewController.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 26/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

protocol CountDownViewControllerDelegate: class
{
    func countdownFinished()
}

class CountDownViewController: UIViewController
{
    weak var delegate: CountDownViewControllerDelegate?
    
    private var timer: Timer?
    private var countdownTimer = 3
    
    let containerView: UIView =
    {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    let tapToStartLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Tap to\nstart"
        label.numberOfLines = 2
        label.font = Appearance.titleFont(with: 36)
        label.textAlignment = .center
        label.textColor = .white
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let countdownLabel: UILabel =
    {
        let label = UILabel()
        label.font = Appearance.titleFont(with: 50)
        label.textAlignment = .center
        label.alpha = 0
        label.textColor = .white
        label.isUserInteractionEnabled = true
        label.text = "3"
        
        return label
    }()
    
    let loadingIndicator: UIActivityIndicatorView =
    {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.translatesAutoresizingMaskIntoConstraints = false
        
        return aiv
    }()
    
    override func viewDidLayoutSubviews()
    {
        containerView.setGradientButton(colorOne: UIColor.lightBlue.cgColor, colorTwo: UIColor.lightPurple.cgColor, startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 0, y: 1))
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        setupViews()
        tapToStartLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startCountdown)))
    }
    
    @objc private func startCountdown()
    {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.tapToStartLabel.alpha = 0
            self.countdownLabel.alpha = 1
            self.countdownLabel.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            
        }) { (completed) in
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                
                self.countdownLabel.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
                
            }, completion: nil)
        }
        
        tapToStartLabel.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleCountdown), userInfo: nil, repeats: true)
    }
    
    @objc private func handleCountdown()
    {
        countdownTimer -= 1
        countdownLabel.text = "\(countdownTimer)"
        
        if countdownTimer == 0
        {
            timer?.invalidate()
            delegate?.countdownFinished()
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.countdownLabel.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            
        }) { (completed) in
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                
                self.countdownLabel.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
                
            }, completion: nil)
        }
    }
    
    private func setupViews()
    {
        view.addSubview(containerView)
        containerView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingRight: 50, paddingBottom: 0, width: 0, height: 160)
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        view.addSubview(tapToStartLabel)
        tapToStartLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        view.addSubview(countdownLabel)
        countdownLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
}
















