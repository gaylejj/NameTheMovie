//
//  Timer.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/21/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import Foundation

class Timer {
    var timerIsRunning = false
    var gameTime = 13.0
    var timerLabelTimer : NSTimer!
    
    init() {
        
    }
    
    //MARK: Timer Setup
    func startTimer() {
        self.timerIsRunning = true
        timerLabelTimer = NSTimer.scheduledTimerWithTimeInterval(0.10, target: self, selector: "subtractTime", userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timerIsRunning = false
        timerLabelTimer.invalidate()
    }
    
    func subtractTime() {
        if self.gameTime > 0.1 {
            var timeLeft = self.gameTime - 0.10
            self.gameTime = timeLeft
        } else {
            self.stopTimer()
        }
    }
    
    //    //MARK: Timer Setup
    //    func startTimer() {
    //        self.timerIsRunning = true
    //        timerLabelTimer = NSTimer.scheduledTimerWithTimeInterval(0.10, target: self, selector: "subtractTime", userInfo: nil, repeats: true)
    //    }
    //
    //    func stopTimer() {
    //        self.timerIsRunning = false
    //        timerLabelTimer.invalidate()
    //    }
    //
    //    func subtractTime() {
    //        if self.gameTime < 5.0 {
    //            self.timerLabel.font = UIFont.systemFontOfSize(48.0)
    //        }
    //        if self.gameTime > 0.1 {
    //            var timeLeft = self.gameTime - 0.10
    //            self.gameTime = timeLeft
    //            self.timerLabel.text = "\(self.nf.stringFromNumber(self.gameTime))"
    //        } else {
    //            self.stopTimer()
    //            self.showCorrectAnswer()
    //        }
    //    }
}