//
//  PlayTransitionAnimator.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 26/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class PlayTransitonAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
    private var sourceButton: UIButton?
    
    convenience init(sourceButton: UIButton)
    {
        self.init()
        self.sourceButton = sourceButton
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.65
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? MenuViewController, let toViewController = transitionContext.viewController(forKey: .to) as? TypeController, let toView = transitionContext.view(forKey: .to), let sourceButton = sourceButton else { return }
        
        let containerView = transitionContext.containerView
        
        toView.frame = transitionContext.finalFrame(for: toViewController)
        toView.alpha = 0
        
        containerView.addSubview(toView)
        
        sourceButton.alpha = 0
        
        let initialFrame = containerView.convert(sourceButton.bounds, from: sourceButton)
        let transitionView = UIButton(frame: initialFrame)
        transitionView.layer.cornerRadius = 12
        transitionView.layer.masksToBounds = true
        transitionView.setGradientButton(colorOne: UIColor.lightBlue.cgColor, colorTwo: UIColor.lightPurple.cgColor, startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 0, y: 1))
        transitionView.setTitle(sourceButton.titleLabel?.text, for: .normal)
        transitionView.setTitleColor(sourceButton.titleLabel?.textColor, for: .normal)
        transitionView.titleLabel?.font = sourceButton.titleLabel?.font
        
        containerView.addSubview(transitionView)
        
        toView.layoutIfNeeded()
        
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        let expandScale = (UIScreen.main.bounds.size.height / toView.frame.size.height) * 2
        expandAnim.fromValue = 1.0
        expandAnim.toValue = max(expandScale, 10.0)
        expandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
        expandAnim.duration = 0.4
        expandAnim.fillMode = .forwards
        expandAnim.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {
            
            fromViewController.view.alpha = 0
            
            UIView.animate(withDuration: 0.25, animations: {
                
                toView.alpha = 1
                transitionView.alpha = 0
                
            }) { (completed) in
                
                transitionView.removeFromSuperview()
                fromViewController.view.alpha = 1
                sourceButton.alpha = 1
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        
        transitionView.layer.add(expandAnim, forKey: expandAnim.keyPath)
        CATransaction.commit()
        UIView.animate(withDuration: 0.4) {
            transitionView.titleLabel?.alpha = 0
        }
    }
}
