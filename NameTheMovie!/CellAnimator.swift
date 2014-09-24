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
    //Animate cell into screen from left
    class func animate(cell: GenreTableViewCell) {
        let view = cell.contentView
        view.frame = CGRect(x: 0 - cell.frame.width, y: 0, width: cell.frame.width, height: cell.frame.height)
        UIView.animateWithDuration(1.2, animations: { () -> Void in
            view.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        })
    }
}