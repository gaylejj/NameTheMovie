//
//  TransitionManager.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 9/12/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class TransitionManager: UIPresentationController, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
   
    //Animate change from one VC to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
       //write Animation Code
        
        //Get reference to our fromView, toView, and containerView we should perform transition in
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey!)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey!)
        
        //setup 2d transforms will use in animation
        let offScreenBottom = CGAffineTransformMakeTranslation(0, container.frame.width)
        let offScreenTop = CGAffineTransformMakeTranslation(0, -container.frame.width)
        
        //Start the toView to the left of the screen
        toView!.transform = offScreenTop
        
        //Add both subviews to VC
        container.addSubview(toView!)
        container.addSubview(fromView!)
        
        //get duration of animation
        let duration = self.transitionDuration(transitionContext)
        
        //Perform animation
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: nil, animations: { () -> Void in
            fromView?.transform = offScreenBottom
            toView!.transform = CGAffineTransformIdentity
        }) { (finished) -> Void in
            
            //Tell transition context that we have finished animating
            transitionContext.completeTransition(true)
        }
    }
    
    //Return how many seconds transition animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 5
    }
    
    //Return animator when presenting a VC
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    //Return animator when dismissing from VC
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        return self
    }

    
}
