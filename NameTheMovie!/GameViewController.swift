//
//  GameViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/12/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit
import QuartzCore

class GameViewController: UIViewController, GameLogicDelegate, QuestionViewControllerDelegate, GameCenterManagerDelegate {
    
    //MARK: Properties/Outlets
    var movies : [Movie]?
    var answer : Movie?
    var genre : Genre?
    let networkController = NetworkController()
    var gameLogic = GameLogic()
    var questions = [Question]()
    var correctAnswers = [Movie]()
    var playerAnswers = [String]()
    var gameStarted = false
    var questionsAnswered = 0
    var score = 0.0
    var countdownTime = 3.0
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    let loadingView = UIImageView()
    let gameButton = UIButton()
    
    let nf = NSNumberFormatter()
    let scoreNF = NSNumberFormatter()
        
    var questionTimer : NSTimer!
    var beginningTimer : NSTimer!
    var countdownTimer : NSTimer!
    var timerLabelTimer : NSTimer!
    
    var timerIsRunning = false
        
    @IBOutlet weak var timerLabel: UILabel!
    
    var questionVC = QuestionViewController()
    
    //MARK: Loading functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 51/255, green: 77/255, blue: 93/255, alpha: 1.0)
        
        self.gameLogic.delegate = self
        self.gameLogic.networkController = self.networkController
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        nf.maximumFractionDigits = 0
        scoreNF.maximumFractionDigits = 0
        
        self.timerLabel.hidden = true
        self.timerLabel!.text! = "\(self.nf.stringFromNumber(self.countdownTime)!)"
                
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "\(genre!.name!)"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.setupQuestionVC()
        self.makeNetworkCall()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.questionVC.view.removeFromSuperview()
        
        self.questionVC.removeFromParentViewController()
    }
    
    //Setup QuestionVC
    
    func setupQuestionVC() {
        self.questionVC = self.storyboard!.instantiateViewControllerWithIdentifier("QuestionVC") as QuestionViewController

        self.questionVC.view.hidden = true
        
        self.view.addSubview(self.questionVC.view)
        
        self.addChildViewController(self.questionVC)
        self.questionVC.didMoveToParentViewController(self)
        self.questionVC.delegate = self
    }
    
    //MARK: Setup Activity Monitor/Button
    
    func setupActivityMonitorAndButton() {
        self.loadingView.frame = CGRectMake(self.view.center.x - 100, self.view.center.y - 100, 200, 200)
        self.gameButton.frame = CGRectMake(self.view.center.x - 100, self.view.center.y - 25, 200, 50)
        self.gameButton.setTitle("Loading Game", forState: UIControlState.Normal)
        self.gameButton.userInteractionEnabled = false
        self.gameButton.addTarget(self, action: "startGameButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.loadingView.animationImages = self.popcornAnimation()
        self.loadingView.animationDuration = 1.2
        self.loadingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(self.loadingView)
        self.loadingView.startAnimating()
//        self.loadingView.addSubview(self.gameButton)
        self.view.addSubview(self.gameButton)
        self.gameButton.alpha = 0.0

    }
    
    func setupReportScoreActivityMonitor() {
        self.loadingView.frame = CGRectMake(self.view.center.x - 100, self.view.center.y - 100, 200, 200)
        self.activityIndicator.frame = CGRectMake(75, 50, 50, 50)
        self.activityIndicator.hidden = false
        self.gameButton.setTitle("Reporting Score", forState: UIControlState.Normal)
        self.gameButton.userInteractionEnabled = false
        self.view.addSubview(self.loadingView)
        self.loadingView.addSubview(self.activityIndicator)
//        self.loadingView.addSubview(self.gameButton)
//        self.view.addSubview(self.gameButton)
        self.gameButton.hidden = false
        self.activityIndicator.startAnimating()
    }
    
    //MARK: Popcorn Animation
    
    func popcornAnimation() -> [UIImage] {
        var images = [UIImage]()
        for i in 0..<15 {
            let image = UIImage(named: "popcorn_\(i)")
            images.append(image!)
        }
        return images
    }
    
    //MARK: Network Call
    
    func makeNetworkCall() {
        self.setupActivityMonitorAndButton()
        let downloadQueue = NSOperationQueue()
        
        downloadQueue.addOperationWithBlock { () -> Void in
            self.networkController.discoverMovie(self.genre!, callback: { (movies, errorDescription) -> Void in
                if let string = errorDescription as String? {
                    
                    self.createAndShowAlertController()
                    
                } else {
                    if movies!.count != 0 {
                        self.gameLogic.movies = movies
                        self.gameLogic.originalMovies = movies
                        self.createGame()
                    } else {
                        println("Found zero movies")
                        
                        self.createAndShowAlertController()
                    }
                }
            })
        }
    }
    
    func createAndShowAlertController() {
        let alertController = UIAlertController(title: "Error", message: "Something happened, we are very sorry. Please try again or go back and choose another genre", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
        let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.makeNetworkCall()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(tryAgainAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
        if questions.count == 5 {
            self.animateGameStart()
        }
    }
    
    func animateGameStart() {
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.gameButton.setTitle("Start Game", forState: UIControlState.Normal)
            self.loadingView.frame = CGRect(x: self.loadingView.frame.origin.x, y: self.view.frame.size.height + self.loadingView.frame.size.height, width: self.loadingView.frame.size.width, height: self.loadingView.frame.size.height)
            self.gameButton.alpha = 1.0
        }) { (succeed) -> Void in
            self.loadingView.stopAnimating()
            self.gameButton.userInteractionEnabled = true
            self.loadingView.userInteractionEnabled = true
        }
    }
    
    func startGameButtonPressed() {
        println("button touched")
        self.beginningTimer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "beginCountdown", userInfo: nil, repeats: false)
        self.countdownTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "beginGame", userInfo: nil, repeats: false)
        self.gameButton.hidden = true
    }
    
    func beginGame() {
        self.displayQuestion(0)
    }
    
    func beginCountdown() {
        self.startTimer()
    }
    
    func displayQuestion(questionsAnswered: Int) {
        if self.questionsAnswered < 5 {
            let question = questions[self.questionsAnswered]
            self.answer = question.movie
            
            self.setupQuestionVC()
            
            self.questionVC.view.frame = CGRect(x: 0-self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            self.questionVC.view.hidden = true
            self.timerLabel.hidden = true
            
            self.questionVC.displayQuestionInVC(question)
        }
    }
    
    //MARK: Delegate response from question answered
    func questionAnswered(correctAnswer: Movie, playerAnswer: String, timeScore : Double) {
        self.correctAnswers.append(correctAnswer)
        self.playerAnswers.append(playerAnswer)
        self.calculateScore(timeScore)
        self.questionWasAnswered()
        self.countdownTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "animateQuestionAfterAnswer", userInfo: nil, repeats: false)

    }
    
    //Animate questionVC to the right off screen
    func animateQuestionAfterAnswer() {

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.questionVC.view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }) { (Bool) -> Void in
            //start countdown timer
            if self.questionsAnswered < 5 {
                self.countdownTime = 3.0
                self.timerLabel.text = "\(self.nf.stringFromNumber(self.countdownTime)!)"
                self.setupNextQuestion()
                self.beginCountdown()
                
                self.questionVC.willMoveToParentViewController(nil)
                self.questionVC.removeFromParentViewController()
                self.questionVC.view.removeFromSuperview()
            } else {
                if GameCenterManager.sharedManager().localPlayerData() != nil {
                    self.reportScore()
                } else {
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
        self.setupReportScoreActivityMonitor()
        GameCenterManager.sharedManager().delegate = self
        
        //Add score to previous score for player from leaderboard
        let score = Int32(self.score)
        let currentScoreFromLeaderboard = GameCenterManager.sharedManager().highScoreForLeaderboard("com.jeff.PopcornQuizHighScore")
        let finalScore = score + currentScoreFromLeaderboard
        
        //Report final score
        GameCenterManager.sharedManager().saveAndReportScore(finalScore, leaderboard: "com.jeff.PopcornQuizHighScore", sortOrder: GameCenterSortOrderHighToLow)
    }
    
    func gameCenterManager(manager: GameCenterManager!, authenticateUser gameCenterLoginController: UIViewController!) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.gameCenterManager(manager, authenticateUser: gameCenterLoginController)
    }

    func gameCenterManager(manager: GameCenterManager!, reportedScore score: GKScore!, withError error: NSError!) {
        var error : NSError?
        if error != nil {
            
        } else {
            self.loadingView.removeFromSuperview()
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
    
    //MARK: Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "Results" {
            let resultsVC = segue.destinationViewController as ResultsViewController
            
            resultsVC.correctAnswers = self.correctAnswers
            resultsVC.playerAnswers = self.playerAnswers
            resultsVC.score = self.score
            
        }
    }
    
    //MARK: Timer Setup
    func startTimer() {
        self.loadingView.removeFromSuperview()
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
            self.timerLabel.text = "\(self.nf.stringFromNumber(self.countdownTime)!)"
        } else {
            self.stopTimer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
