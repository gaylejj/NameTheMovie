//
//  IrisTransition.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 9/15/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class IrisTransition: UIStoryboardSegue {
    
    override func perform() {
        let source = self.sourceViewController as GenreViewController
        let destination = self.destinationViewController as GameViewController
        
        destination.view.frame = CGRect(x: 0, y: 0 - source.view.frame.height, width: destination.view.frame.width, height: destination.view.frame.height)
        source.view.addSubview(destination.view)
        
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            
            destination.view.frame = CGRect(x: source.view.frame.origin.x, y: source.view.frame.origin.y, width: destination.view.frame.width, height: destination.view.frame.height)
            
        }) { (finished) -> Void in
            destination.view.removeFromSuperview()

            source.presentViewController(destination, animated: false, completion: nil)

        }
        
//        let view = UIView(frame: CGRectMake(source.view.frame.origin.x, source.view.frame.origin.y, source.view.frame.width, source.view.frame.height))
//        view.backgroundColor = UIColor.clearColor()
//        var circle = UIView(frame: CGRectMake(source.view.frame.origin.x - 250, source.view.frame.origin.y, 1000, 1000))
//        
////        source.view.addSubview(destination.view)
//        source.view.addSubview(view)
//        view.addSubview(circle)
//        
//        circle.layer.cornerRadius = circle.frame.width / 2
//        circle.backgroundColor = UIColor(red: 88/255, green: 167/255, blue: 210/255, alpha: 1.0)
        
//        UIView.animateWithDuration(1.5, animations: { () -> Void in
//        
//            circle.frame = CGRect(x: source.view.frame.origin.x - 250, y: source.view.frame.origin.y, width: 5, height: 5)
//            
//        }) { (finished) -> Void in
//            destination.view.removeFromSuperview()
//            UIView.animateWithDuration(1.5, animations: { () -> Void in
//                circle.frame = CGRect(x: source.view.frame.origin.x - 250, y: source.view.frame.origin.y, width: 1000, height: 1000)
//            }, completion: { (finished) -> Void in
//                source.presentViewController(destination, animated: false, completion: nil)
//                destination.movies = source.movies
//            })
//        }
    }
   
}
