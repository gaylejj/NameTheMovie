//
//  GameViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/12/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameLogicDelegate, QuestionViewControllerDelegate, GameCenterManagerDelegate {
    
    var movies : [Movie]?
        
    var answer : Movie?
    
    var genre : Genre?
    
    let networkController = NetworkController()
    
    var gameLogic = GameLogic()
    
    var questions = [Question]()
    
    var correctAnswers = [String]()
    
    var playerAnswers = [String]()
    
    var gameStarted = false
    
    var questionsAnswered = 0
    
    var score = 0.0
    var countdownTime = 3.0
    
    let nf = NSNumberFormatter()
    let scoreNF = NSNumberFormatter()
        
    var questionTimer : NSTimer!
    var questionTimerTwo : NSTimer!
    var beginningTimer : NSTimer!
    var countdownTimer : NSTimer!
    var timerLabelTimer : NSTimer!
    
    var questionHasBeenAnswered = false
    var timerIsRunning = false
        
    @IBOutlet weak var timerLabel: UILabel!
    
    var questionVCOne = QuestionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 51/255, green: 77/255, blue: 93/255, alpha: 1.0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.gameLogic.delegate = self
        self.gameLogic.movies = self.movies!
        self.gameLogic.originalMovies = self.movies!
        self.gameLogic.networkController = self.networkController
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        nf.maximumFractionDigits = 0
        
        scoreNF.maximumFractionDigits = 0
        
        self.createGame()

        self.beginningTimer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "beginCountdown", userInfo: nil, repeats: false)
        self.countdownTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "beginGame", userInfo: nil, repeats: false)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupQuestionVC()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.questionVCOne.view.removeFromSuperview()
        
        self.questionVCOne.removeFromParentViewController()
    }
    
    func beginGame() {
        self.displayQuestion(0)
    }
    
    func beginCountdown() {
        self.startTimer()
    }
    
    func setupQuestionVC() {
        self.questionVCOne = self.storyboard!.instantiateViewControllerWithIdentifier("QuestionVC") as QuestionViewController

        self.questionVCOne.view.hidden = true
        
        self.view.addSubview(questionVCOne.view)
        
        self.addChildViewController(questionVCOne)
        self.questionVCOne.delegate = self
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
            self.gameStarted = true
        }
    }
    
    func displayQuestion(questionsAnswered: Int) {
        if self.questionsAnswered < 5 {
            let question = questions[self.questionsAnswered]
            self.answer = question.movie
            
            questionVCOne.view.frame = CGRect(x: 0-self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            self.questionVCOne.view.hidden = true
            self.timerLabel.hidden = true
            
            self.questionVCOne.displayQuestionInVC(question)
        }
    }
    
    func questionAnswered(correctAnswer: String, playerAnswer: String, timeScore : Double) {
        self.correctAnswers.append(correctAnswer)
        self.playerAnswers.append(playerAnswer)
        self.calculateScore(timeScore)
        self.questionWasAnswered()
        self.countdownTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "animateQuestionAfterAnswer", userInfo: nil, repeats: false)

    }
    
    func animateQuestionAfterAnswer() {

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.questionVCOne.view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }) { (Bool) -> Void in
            //start countdown timer
            if self.questionsAnswered < 5 {
                self.countdownTime = 3.0
                self.timerLabel.text = "\(self.nf.stringFromNumber(self.countdownTime))"
                self.setupNextQuestion()
                self.beginCountdown()
            } else {
                if GameCenterManager.sharedManager().localPlayerData() != nil {
                    self.reportScore()
                } else {
                    println("No Player found")
                    self.performSegueWithIdentifier("Results", sender: self)
                }
            }
        }
    }
    
    func setupNextQuestion() {
        self.questionTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "displayQuestion:", userInfo: nil, repeats: false)
    }
    
    func questionWasAnswered() {
        self.questionsAnswered++
        
        if self.questionsAnswered == 5 {
            gameStarted = false
        }
    }
    
    //MARK: GameCenter Score

    func reportScore() {
        GameCenterManager.sharedManager().delegate = self
        let score = Int32(self.score)
        let currentScoreFromLeaderboard = GameCenterManager.sharedManager().highScoreForLeaderboard("com.jeff.PopcornQuizHighScore")
        let finalScore = score + currentScoreFromLeaderboard
        println(finalScore)
        GameCenterManager.sharedManager().saveAndReportScore(finalScore, leaderboard: "com.jeff.PopcornQuizHighScore", sortOrder: GameCenterSortOrderHighToLow)
    }
    
    func gameCenterManager(manager: GameCenterManager!, authenticateUser gameCenterLoginController: UIViewController!) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.gameCenterManager(manager, authenticateUser: gameCenterLoginController)
    }

    func gameCenterManager(manager: GameCenterManager!, reportedScore score: GKScore!, withError error: NSError!) {
        var error : NSError?
        if error != nil {
            println(error?.localizedDescription)
        } else {
            self.performSegueWithIdentifier("Results", sender: self)
        }
    }
    
    func calculateScore(gameTimeRemaining: Double) {
        if gameTimeRemaining > 10.0 {
            let maxScoreTimeValue = 1000.0
            self.score = (self.score + maxScoreTimeValue)
        } else {
            var scoreTimeValue = Double(gameTimeRemaining) * 100
            self.score = (self.score + scoreTimeValue)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "Results" {
            let resultsVC = segue.destinationViewController as ResultsViewController
            
            resultsVC.correctAnswers = self.correctAnswers
            resultsVC.playerAnswers = self.playerAnswers
            resultsVC.score = self.score
//            resultsVC.genre = self.genre
//            resultsVC.movies = self.movies!
            
        }
    }
    
    //MARK: Timer Setup
    func startTimer() {
        self.timerLabel.hidden = false
        self.timerIsRunning = true
        timerLabelTimer = NSTimer.scheduledTimerWithTimeInterval(0.10, target: self, selector: "subtractTime", userInfo: nil, repeats: true)
    }

    func stopTimer() {
        self.timerIsRunning = false
        timerLabelTimer.invalidate()
    }
    
    func subtractTime() {
        if self.countdownTime > 0.1 {
            var timeLeft = self.countdownTime - 0.10
            self.countdownTime = timeLeft
            self.timerLabel.text = "\(self.nf.stringFromNumber(self.countdownTime))"
        } else {
            self.stopTimer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
