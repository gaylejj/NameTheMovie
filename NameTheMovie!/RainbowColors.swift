//
//  RainbowColors.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/17/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import Foundation

class RainbowColors: NSObject {
    var r : CGFloat
    var g : CGFloat
    var b : CGFloat
    var a : CGFloat
    
    init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    
    class func colorsFromPlist() -> Array<RainbowColors> {
        var colors = Array<RainbowColors>()
        
        let path = NSBundle.mainBundle().pathForResource("ColorsPList", ofType: "plist")
        
        let plistArray = NSArray(contentsOfFile: path!)
        
        for obj in plistArray {
            if let color = obj as? Dictionary<String, Int> {
                let rInt = color["r"] as Int!
                let gInt = color["g"] as Int!
                let bInt = color["b"] as Int!
                let aInt = color["a"] as Int!
                let r = CGFloat(rInt)
                let g = CGFloat(gInt)
                let b = CGFloat(bInt)
                let a = CGFloat(aInt)
                
                colors.append(RainbowColors(r: r, g: g, b: b, a: a))
            }
        }
        return colors
    }
}