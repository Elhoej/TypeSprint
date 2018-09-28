//
//  YouWonView.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

protocol YouWonViewControllerDelegate: class
{
    func dismissToMenu()
    func startNewRace()
}

class YouWonViewController: UIViewController
{
    weak var delegate: YouWonViewControllerDelegate?
    
    let wonLabel: UILabel =
    {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    let newRaceButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Appearance.titleFont(with: 18)
        button.setTitle("New race", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleNewRace), for: .touchUpInside)
        
        return button
    }()
    
    let menuButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Appearance.titleFont(with: 18)
        button.setTitle("Menu", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleMenu), for: .touchUpInside)
        
        return button
    }()
    
    let containerView: UIView =
    {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.backgroundColor = .darkColor
        
        return view
    }()
    
    override func viewDidLayoutSubviews()
    {
        menuButton.layer.cornerRadius = menuButton.frame.height / 2
        newRaceButton.layer.cornerRadius = newRaceButton.frame.height / 2
        menuButton.setGradientButton(colorOne: UIColor.lightBlue.cgColor, colorTwo: UIColor.lightPurple.cgColor, startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        newRaceButton.setGradientButton(colorOne: UIColor.correctGreen.cgColor, colorTwo: UIColor.lightPurple.cgColor, startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 0, y: 1))
    }
    
    @objc private func handleNewRace()
    {
        dismiss(animated: true) {
            self.delegate?.startNewRace()
        }
    }
    
    @objc func handleMenu()
    {
        dismiss(animated: false) {
            self.delegate?.dismissToMenu()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        setupViews()
    }
    
    private func setupViews()
    {
        view.addSubview(containerView)
        containerView.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 400)
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        containerView.addSubview(wonLabel)
        wonLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, paddingBottom: 0, width: 0, height: 200)
        
        let stackView = UIStackView(arrangedSubviews: [newRaceButton, menuButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        
        containerView.addSubview(stackView)
        stackView.anchor(top: wonLabel.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12, paddingBottom: -12, width: 0, height: 0)
    }
}
