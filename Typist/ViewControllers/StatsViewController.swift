//
//  StatsViewController.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, UIViewControllerTransitioningDelegate
{
    var wpmDoubles = [Double]()
    {
        didSet
        {
            statsView.wpmDoubles = wpmDoubles
        }
    }
    var averageWpm: Int?
    {
        didSet
        {
            statsView.averageWpm = averageWpm
        }
    }
    
    let swipeLineIndicator: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 1.0, alpha: 0.8)
        view.layer.cornerRadius = 1
        
        return view
    }()
    
    let statsView: StatsView =
    {
        let sv = StatsView()
        sv.isUserInteractionEnabled = true

        return sv
    }()
    
    @objc private func handleDismiss()
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        
        view.addSubview(statsView)
        statsView.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 500)
        statsView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        statsView.addSubview(swipeLineIndicator)
        swipeLineIndicator.anchor(top: nil, left: nil, bottom: statsView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: -8, width: 100, height: 2)
        swipeLineIndicator.centerXAnchor.constraint(equalTo: statsView.centerXAnchor).isActive = true
        
        statsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    
    
    
}






