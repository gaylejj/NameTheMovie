//
//  GameViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/12/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameLogicDelegate {
    
    var movies : [Movie]?
    
    var answer : Movie?
    
    let networkController = NetworkController()
    
    var gameLogic = GameLogic()
    
    var questions = [Question]()
    
    var gameStarted = false
    
    var questionsAnswered = 0
    
    var score = 0.0
    
    var gameTime = 10.0
    
    let nf = NSNumberFormatter()
    let scoreNF = NSNumberFormatter()
    
//    var delegate : TTCounterLabelDelegate?
    
    var questionTimer : NSTimer!
    var questionTimerTwo : NSTimer!
    var timerLabelTimer : NSTimer!
    
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet weak var thirdButton: UIButton!
    
    @IBOutlet weak var fourthButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var alertView = UIAlertController(title: "Score!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameLogic.delegate = self
        self.gameLogic.movies = self.movies!
        self.gameLogic.originalMovies = self.movies!
        self.gameLogic.networkController = self.networkController
        self.overviewTextView.scrollEnabled = true
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 1
        scoreNF.maximumFractionDigits = 0
        
        self.createGame()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    //MARK: Game Functions
    
    func createGame() {
        var i = 0
        while i < 5 {
            self.gameLogic.fetchQuestion()
            i++
        }
    }
    
    func generatedQuestion(question: Question) {
        questions.append(question)
        if gameStarted == false {
            gameStarted = true
            displayQuestion(self.questionsAnswered)
        }
//        println(question.movie?.title)
//        println("Generated Question Overview is \(question.movie?.overview)")

    }
    
    func displayQuestion(questionsAnswered: Int) {
        
        if self.questionsAnswered < 5 {
            let question = questions[self.questionsAnswered]
            self.answer = question.movie
            
            var overview = "\(question.movie!.overview!)"
            let newOverview = overview.stringByReplacingOccurrencesOfString(question.movie!.title!, withString: "________", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
            
            self.overviewTextView.text = newOverview
            
            self.resetButtonTitleColor()
            
            self.firstButton.setTitle(question.answers[0].title, forState: UIControlState.Normal)
            
            self.secondButton.setTitle(question.answers[1].title, forState: UIControlState.Normal)
            self.thirdButton.setTitle(question.answers[2].title, forState: UIControlState.Normal)
            self.fourthButton.setTitle(question.answers[3].title, forState: UIControlState.Normal)
            
            self.enableUserInteraction()
            
            println("Question displayed")
            self.gameTime = 10.00
            self.timerLabel.text = "\(self.gameTime)"
            self.startTimer()
            
        } else {
            self.displayScore()
        }

    }
    
    func questionWasAnswered() {
        self.questionsAnswered++
        
        if self.questionsAnswered == 5 {
            gameStarted = false
            //            self.displayScore()
            
            //        } else if self.questions.count - self.questionsAnswered <= 2 && self.questionsAnswered < (self.movies!.count/4) {
            //            println(self.questions.count)
            //            println(self.questionsAnswered)
            //            self.gameLogic.fetchQuestion()
        }
    }

    @IBAction func nextQuestion(sender: UIButton!) {
        println(sender.currentTitle)
        self.stopTimer()
        if sender.currentTitle {
            if sender.currentTitle == self.answer?.title {
//                self.score++
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    sender.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                    self.calculateScore()
                })
            } else {
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    sender.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                })
            }
            self.disableUserInteraction()
            
            self.questionTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "questionWasAnswered", userInfo: nil, repeats: false)
            self.questionTimerTwo = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "displayQuestion:", userInfo: nil, repeats: false)
        }
    }
    
    func displayScore() {
        self.disableUserInteraction()
        
        var scoreAlert = UIAlertAction(title: "Score was \(self.scoreNF.stringFromNumber(self.score))", style: UIAlertActionStyle.Default, handler: nil)
        
        self.alertView.addAction(scoreAlert)
        self.resetViewController()

        self.presentViewController(self.alertView, animated: true) { () -> Void in

        }
        
    }
    
    //MARK: Timer Setup
    func startTimer() {
        timerLabelTimer = NSTimer.scheduledTimerWithTimeInterval(0.10, target: self, selector: "subtractTime", userInfo: nil, repeats: true)
        println(self.gameTime)
    }
    
    func stopTimer() {
        timerLabelTimer.invalidate()
        println(self.gameTime)
    }
    
    func subtractTime() {
        var timeLeft = self.gameTime - 0.10
        self.gameTime = timeLeft
        self.timerLabel.text = "\(self.nf.stringFromNumber(self.gameTime))"
    }
    
    func calculateScore() {
        var scoreTimeValue = Double(self.gameTime) * 100
        self.score = (self.score + scoreTimeValue)
        println(self.nf.stringFromNumber(self.score))
    }


    
    //MARK: UIInteractions
    func resetButtonTitleColor() {
        self.firstButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.secondButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.thirdButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.fourthButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    }
    
    func disableUserInteraction() {
        self.firstButton.userInteractionEnabled = false
        self.secondButton.userInteractionEnabled = false
        self.thirdButton.userInteractionEnabled = false
        self.fourthButton.userInteractionEnabled = false
    }
    
    func enableUserInteraction() {
        self.firstButton.userInteractionEnabled = true
        self.secondButton.userInteractionEnabled = true
        self.thirdButton.userInteractionEnabled = true
        self.fourthButton.userInteractionEnabled = true
    }
    
    func resetViewController() {
        self.overviewTextView.text = ""
        self.firstButton.setTitle("", forState: UIControlState.Normal)
        self.secondButton.setTitle("", forState: UIControlState.Normal)
        self.thirdButton.setTitle("", forState: UIControlState.Normal)
        self.fourthButton.setTitle("", forState: UIControlState.Normal)
        self.timerLabel.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
