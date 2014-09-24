//
//  AnimationController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 9/15/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import Foundation

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    //Transition Duration
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 2.0
    }
    
    //Animation for Transition
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var containerView = transitionContext.containerView()
        
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        var fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        var toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        toVC!.view.frame = CGRect(x: 0, y: 0 - toVC!.view.frame.height, width: toVC!.view.frame.width, height: toVC!.view.frame.height)
        
        containerView.addSubview(toVC!.view)
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            toVC!.view.frame = CGRect(x: fromVC!.view.frame.origin.x, y: fromVC!.view.frame.origin.y, width: toVC!.view.frame.width, height: toVC!.view.frame.height)
        }) { (finished) -> Void in
            transitionContext.completeTransition(!(transitionContext.transitionWasCancelled()))
        }
    }
}