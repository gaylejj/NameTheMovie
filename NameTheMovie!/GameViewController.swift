//
//  GameViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/12/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameLogicDelegate, QuestionViewControllerDelegate {
    
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
    
    let nf = NSNumberFormatter()
    let scoreNF = NSNumberFormatter()
        
    var questionTimer : NSTimer!
    var questionTimerTwo : NSTimer!
//    var beginningTimer : NSTimer!
//    var showAnswersTimer : NSTimer!
//    var scoreTimer : NSTimer!
    var countdownTimer : NSTimer!
    
    var questionHasBeenAnswered = false
    var timerIsRunning = false
        
    @IBOutlet weak var timerLabel: UILabel!
    
//    @IBOutlet weak var collectionView : UICollectionView!
    
    var questionVCOne = QuestionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 88/255, green: 167/255, blue: 210/255, alpha: 1.0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.gameLogic.delegate = self
        self.gameLogic.movies = self.movies!
        self.gameLogic.originalMovies = self.movies!
        self.gameLogic.networkController = self.networkController
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 1
        
        scoreNF.maximumFractionDigits = 0
        
        self.createGame()
        self.countdownTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "beginGame", userInfo: nil, repeats: false)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    func setupQuestionVC() {
        self.questionVCOne = self.storyboard.instantiateViewControllerWithIdentifier("QuestionVC") as QuestionViewController

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
        let question = questions[self.questionsAnswered]
        self.answer = question.movie
        
        questionVCOne.view.frame = CGRect(x: 0-self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.questionVCOne.view.hidden = true
        
        self.questionVCOne.displayQuestionInVC(question)
        
        
//        self.timerLabel.font = UIFont.systemFontOfSize(18.0)
//        self.collectionView.hidden = true
//        if self.questionsAnswered < 5 {
//            self.gameTime = 13.0
//            let question = questions[self.questionsAnswered]
//            self.answer = question.movie
//            
//            println("Display question \(self.gameStarted)")
//            var overview = "\(question.movie!.overview!)"
//            let newOverview = overview.stringByReplacingOccurrencesOfString(question.movie!.title!, withString: "________", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
//            
//            self.overviewTextView.text = newOverview
//            self.overviewTextView.scrollEnabled = true
//            
//            self.enableUserInteraction()
//            self.questionHasBeenAnswered = false
//            
//            println("Question displayed")
//            self.timerLabel.text = "\(self.gameTime)"
//            self.collectionView.reloadData()
//            if self.questionHasBeenAnswered == false {
//                self.beginningTimer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "startTimer", userInfo: nil, repeats: false)
//                self.showAnswersTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "displayAnswers", userInfo: nil, repeats: false)
//            }
//            
//        } else {
//            self.displayScore()
//        }

    }
    
    func questionAnswered(correctAnswer: String, playerAnswer: String) {
        self.correctAnswers.append(correctAnswer)
        self.playerAnswers.append(playerAnswer)
        self.countdownTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "setupNextQuestion", userInfo: nil, repeats: false)

    }
    
    func setupNextQuestion() {
        self.questionTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "questionWasAnswered", userInfo: nil, repeats: false)
        self.questionTimerTwo = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "displayQuestion:", userInfo: nil, repeats: false)
    }
    
    func questionWasAnswered() {
        self.questionsAnswered++
        
        if self.questionsAnswered == 5 {
            gameStarted = false
        }
    }
    
    func displayScore() {
        self.performSegueWithIdentifier("Results", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "Results" {
            let resultsVC = segue.destinationViewController as ResultsViewController
            
            resultsVC.correctAnswers = self.correctAnswers
            resultsVC.playerAnswers = self.playerAnswers
            resultsVC.score = self.score
            resultsVC.genre = self.genre
            resultsVC.movies = self.movies!
            
        }
    }
    
    func calculateScore() {
        let timerVC = Timer()
        if timerVC.gameTime > 10.0 {
            let maxScoreTimeValue = 1000.0
            self.score = (self.score + maxScoreTimeValue)
        } else {
            var scoreTimeValue = Double(timerVC.gameTime) * 100
            self.score = (self.score + scoreTimeValue)
        }
    }
    
    //MARK: GameCenter Score
    
    func reportScoreToGameCenter() {
        let gamekitHelper = GameKitHelper()
        var gamecenterScore = GKScore(leaderboardIdentifier: gamekitHelper.leaderboardIdentifier)
        println("Identifier \(gamekitHelper.leaderboardIdentifier)")
        gamecenterScore.value = Int64(self.score)
        
        GKScore.reportScores([gamecenterScore], withCompletionHandler: { (error: NSError!) -> Void in
            if error != nil {
                println(error.localizedDescription)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    - (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) identifier
    {
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKLeaderboard reportScores:scores withCompletionHandler:^(NSError *error) {
    //Do something interesting here.
    }];
    }
    */

}
