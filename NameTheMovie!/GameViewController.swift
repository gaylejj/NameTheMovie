//
//  GameViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/12/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameLogicDelegate, TTCounterLabelDelegate {
    
    var movies : [Movie]?
    
    var answer : Movie?
    
    let networkController = NetworkController()
    
    var gameLogic = GameLogic()
    
    var questions = [Question]()
    
    var gameStarted = false
    
    var questionsAnswered = 0
    
    var score = 0
    
    var questionTimer : NSTimer!
    var questionTimerTwo : NSTimer!
    var backTimer : NSTimer!
    
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet weak var thirdButton: UIButton!
    
    @IBOutlet weak var fourthButton: UIButton!
    
    @IBOutlet weak var timerLabel: TTCounterLabel!
    
    @IBOutlet weak var firstAnswerLabel: UILabel!
    @IBOutlet weak var secondAnswerLabel: UILabel!
    @IBOutlet weak var thirdAnswerLabel: UILabel!
    @IBOutlet weak var fourthAnswerLabel: UILabel!
    
    var alertView = UIAlertController(title: "Score!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
    var correctAnswerAlertView = UIAlertController(title: "Correct", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
    var incorrectAnswerAlertView = UIAlertController(title: "Incorrect", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameLogic.delegate = self
        self.gameLogic.movies = self.movies!
        self.gameLogic.originalMovies = self.movies!
        self.gameLogic.networkController = self.networkController
        self.overviewTextView.scrollEnabled = true
        self.gameLogic.fetchQuestion()
        self.gameLogic.fetchQuestion()
        self.setupAlertViews()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func generatedQuestion(question: Question) {
        questions.append(question)
        if gameStarted == false {
            gameStarted = true
            displayQuestion()
        }
//        println(question.movie?.title)
//        println("Generated Question Overview is \(question.movie?.overview)")

    }
    
    func displayQuestion() {
        //Text labels for index 0
        let question = questions[0]
        self.answer = question.movie
        
        var overview = "\(question.movie!.overview!)"
        let newOverview = overview.stringByReplacingOccurrencesOfString(question.movie!.title!, withString: "________", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        self.overviewTextView.text = newOverview
        
        self.resetButtonTitleColor()

//        self.firstAnswerLabel.text = question.answers[0].title
//        self.firstAnswerLabel.numberOfLines = 0
//        self.firstAnswerLabel.sizeToFit()
//        
//        self.secondAnswerLabel.text = question.answers[1].title
//        self.secondAnswerLabel.numberOfLines = 0
//        self.secondAnswerLabel.sizeToFit()
//
//        self.thirdAnswerLabel.text = question.answers[2].title
//        self.thirdAnswerLabel.numberOfLines = 0
//        self.thirdAnswerLabel.sizeToFit()
//
//        self.fourthAnswerLabel.text = question.answers[3].title
//        self.fourthAnswerLabel.numberOfLines = 0
//        self.fourthAnswerLabel.sizeToFit()
        
        self.firstButton.setTitle(question.answers[0].title, forState: UIControlState.Normal)
        
        self.secondButton.setTitle(question.answers[1].title, forState: UIControlState.Normal)
        self.thirdButton.setTitle(question.answers[2].title, forState: UIControlState.Normal)
        self.fourthButton.setTitle(question.answers[3].title, forState: UIControlState.Normal)

        self.questions.removeAtIndex(0)
        
        self.enableUserInteraction()

        println("Question displayed")

    }

    @IBAction func nextQuestion(sender: UIButton!) {
        println(sender.currentTitle)
        if sender.currentTitle {
            if sender.currentTitle == self.answer?.title {
                self.score++
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    sender.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                })
            } else {
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    sender.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                })
            }
            self.disableUserInteraction()
            
            self.questionTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "questionWasAnswered", userInfo: nil, repeats: false)
            self.questionTimerTwo = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "displayQuestion", userInfo: nil, repeats: false)
        }
    }
    
    func questionWasAnswered() {
        self.questionsAnswered++

        if self.questionsAnswered == self.movies!.count/4 {
            gameStarted = false
            self.displayScore()

        } else if self.questions.count - self.questionsAnswered <= 2 && self.questionsAnswered < (self.movies!.count/4) {
            println(self.questions.count)
            println(self.questionsAnswered)
            self.gameLogic.fetchQuestion()
        }
    }
    
    func displayScore() {
        self.disableUserInteraction()
        
        var scoreAlert = UIAlertAction(title: "Score was \(self.score)", style: UIAlertActionStyle.Default, handler: nil)
        
        self.alertView.addAction(scoreAlert)
        self.presentViewController(self.alertView, animated: true) { () -> Void in
            self.resetViewController()

        }
        
    }
    
    func backToMainScreen() {
        println("Timer has started")
        self.navigationController.popToRootViewControllerAnimated(true)
    }
    
    func setupAlertViews() {
        var correct = UIAlertAction(title: "Correct!", style: UIAlertActionStyle.Default, handler: nil)
        var incorrect = UIAlertAction(title: "Incorrect!", style: UIAlertActionStyle.Default, handler: nil)

        self.correctAnswerAlertView.addAction(correct)
        self.incorrectAnswerAlertView.addAction(incorrect)
    }
    
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

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
