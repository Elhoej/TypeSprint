//
//  ProgressView.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 30/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class ProgressView: UIView
{
    var path: UIBezierPath?
    
    let carImageView: UIImageView =
    {
        let iv = UIImageView()
        iv.image = UIImage(named: "car-avatar")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .lightBlue
        
        return iv
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupImageView()
    }
    
    func animateAvatar(index: Int, count: Int)
    {
        let completePercentage = CGFloat(Double(index) / Double(count))
        let width = self.frame.width - 60
        let progressValue = completePercentage * width

        imageViewLeftAnchor?.constant = progressValue
        
        UIView.animate(withDuration: 0.15) {
            self.layoutIfNeeded()
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        let lineWidth: CGFloat = 1
        path = UIBezierPath()
        path?.move(to: CGPoint(x: 0, y: self.bounds.maxY - lineWidth))
        path?.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY - lineWidth))
        path?.lineWidth = lineWidth
        UIColor.white.setStroke()
        path?.stroke()
    }
    
    var imageViewLeftAnchor: NSLayoutConstraint?
    
    private func setupImageView()
    {
        addSubview(carImageView)
        carImageView.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 13, width: 60, height: 60)
        imageViewLeftAnchor = carImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        imageViewLeftAnchor?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}












