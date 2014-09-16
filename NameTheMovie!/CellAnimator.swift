//
//  CellAnimator.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 9/10/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import Foundation
import UIKit

class CellAnimator {
    class func animate(cell: GenreTableViewCell) {
        let view = cell.contentView
        view.frame = CGRect(x: 0 - cell.frame.width, y: 0, width: cell.frame.width, height: cell.frame.height)
        UIView.animateWithDuration(1.2, animations: { () -> Void in
            view.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        })
    }
    
    class func animateCellOff(cell: GenreTableViewCell, completion: () -> Void) {
        let view = cell.contentView
        view.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            view.frame = CGRect(x: 0 + cell.frame.width, y: 0, width: cell.frame.width, height: cell.frame.height)
        })
    }
}