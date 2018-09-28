//
//  LeaderboardViewController.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UIViewControllerTransitioningDelegate
{
    let leaderboardTableViewController = LeaderboardTableViewController()
    
    let containerView: UIView =
    {
        let view = UIView()
        view.backgroundColor = .darkColor
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    let leaderboardLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont(name: "orange juice", size: 40)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "LEADERBOARD"
//        label.sizeToFit()
        
        return label
    }()
    
    let swipeLineIndicator: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 1.0, alpha: 0.8)
        view.layer.cornerRadius = 1
        
        return view
    }()
    
    @objc private func handleDismiss()
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        
        setupViews()
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    private func setupViews()
    {
        view.addSubview(containerView)
        containerView.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 500)
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        containerView.addSubview(leaderboardLabel)
        leaderboardLabel.anchor(top: containerView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 40)
        leaderboardLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.addSubview(leaderboardTableViewController.view)
        leaderboardTableViewController.view.anchor(top: leaderboardLabel.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 12, paddingLeft: 8, paddingRight: 8, paddingBottom: -40, width: 0, height: 0)
        
        containerView.addSubview(swipeLineIndicator)
        swipeLineIndicator.anchor(top: nil, left: nil, bottom: containerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: -8, width: 100, height: 2)
        swipeLineIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    }
    
    
    
    
}
