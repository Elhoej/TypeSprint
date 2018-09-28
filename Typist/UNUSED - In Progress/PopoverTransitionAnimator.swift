//
//  PopoverTransitionAnimator.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class PopoverTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? MenuViewController, let toViewController = transitionContext.viewController(forKey: .to) as? StatsViewController, let toView = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        toView.frame = transitionContext.finalFrame(for: toViewController)
        toView.alpha = 0
        containerView.addSubview(toView)
        
        let transitionView = toViewController.statsView
        transitionView.center.y += toView.frame.midY
        containerView.addSubview(transitionView)
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: .curveEaseIn, animations: {
            
            transitionView.center.y -= toView.frame.midY + 100
            toView.alpha = 0.7
            
        }) { (completed) in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                transitionView.center.y += 100
                toView.alpha = 1.0
                
            }, completion: { (completed) in
                
                transitionView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        }
    }
}
