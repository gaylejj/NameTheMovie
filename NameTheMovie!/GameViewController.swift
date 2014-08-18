//
//  GameViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/12/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GameLogicDelegate {
    
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
    
    var gameTime = 12.0
    
    let nf = NSNumberFormatter()
    let scoreNF = NSNumberFormatter()
        
    var questionTimer : NSTimer!
    var questionTimerTwo : NSTimer!
    var timerLabelTimer : NSTimer!
    var beginningTimer : NSTimer!
    var scoreTimer : NSTimer!
    
    var questionHasBeenAnswered = false
    var timerIsRunning = false
    
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView : UICollectionView!
        
    var alertView = UIAlertController(title: "Score!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 88/255, green: 167/255, blue: 210/255, alpha: 1.0)
        self.overviewTextView.backgroundColor = UIColor(red: 88/255, green: 167/255, blue: 210/255, alpha: 1.0)
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
            self.displayQuestion(self.questionsAnswered)
        }
    }
    
    func displayQuestion(questionsAnswered: Int) {
        self.timerLabel.font = UIFont.systemFontOfSize(18.0)
        if self.questionsAnswered < 5 {
            self.gameTime = 12.0
            let question = questions[self.questionsAnswered]
            self.answer = question.movie
            
            println("Display question \(self.gameStarted)")
            var overview = "\(question.movie!.overview!)"
            let newOverview = overview.stringByReplacingOccurrencesOfString(question.movie!.title!, withString: "________", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
            
            self.overviewTextView.text = newOverview
            self.overviewTextView.scrollEnabled = true
            
            self.enableUserInteraction()
            self.questionHasBeenAnswered = false
            
            println("Question displayed")
            self.timerLabel.text = "\(self.gameTime)"
            self.collectionView.reloadData()
            if self.questionHasBeenAnswered == false {
                self.beginningTimer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "startTimer", userInfo: nil, repeats: false)
            }
            
        } else {
            self.displayScore()
        }

    }
    
    func questionWasAnswered() {
        self.questionsAnswered++
        
        if self.questionsAnswered == 5 {
            gameStarted = false
        }
    }
    
    func displayScore() {
        self.disableUserInteraction()
        
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
        if self.gameTime < 5.0 {
            self.timerLabel.font = UIFont.systemFontOfSize(48.0)
        }
        if self.gameTime > 0.1 {
            var timeLeft = self.gameTime - 0.10
            self.gameTime = timeLeft
            self.timerLabel.text = "\(self.nf.stringFromNumber(self.gameTime))"
        } else {
            self.stopTimer()
            self.showCorrectAnswer()
        }
    }
    
    func calculateScore() {
        if self.gameTime > 10.0 {
            let maxScoreTimeValue = 1000.0
            self.score = (self.score + maxScoreTimeValue)
        } else {
            var scoreTimeValue = Double(self.gameTime) * 100
            self.score = (self.score + scoreTimeValue)
        }
    }
    
    func showCorrectAnswer() {

        var indexPaths = collectionView.indexPathsForVisibleItems()
        
        for indexPath in indexPaths {
            self.disableUserInteraction()
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath as NSIndexPath) as GameCollectionViewCell
            
            if cell.collectionAnswerLabel.text == self.answer?.title {
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    cell.collectionAnswerLabel.textColor = UIColor.greenColor()
                })
                
                self.correctAnswers.append(cell.collectionAnswerLabel.text)
                
                if questionHasBeenAnswered == false {
                    self.playerAnswers.append("___")
                    self.questionTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "questionWasAnswered", userInfo: nil, repeats: false)
                    self.questionTimerTwo = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "displayQuestion:", userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    //MARK: UICollectionView Data Source
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        if !self.questions.isEmpty {
            let question = self.questions[self.questionsAnswered]
            return question.answers.count
            } else {
                return 0
            }
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("answer", forIndexPath: indexPath) as GameCollectionViewCell
        
        let question = self.questions[self.questionsAnswered]
        self.resetCollectionViewColor(cell)
        
        cell.collectionAnswerLabel.text = question.answers[indexPath.row].title
        if cell != nil {
            cell.collectionAnswerLabel.numberOfLines = 0
            cell.collectionAnswerLabel.adjustsFontSizeToFitWidth = true
        }
        
        return cell
    }
    
    //MARK: UICollectionView Delegate
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        self.questionHasBeenAnswered = true
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as GameCollectionViewCell

        self.playerAnswers.append(cell.collectionAnswerLabel.text)
        
        if self.timerIsRunning == true {
            self.stopTimer()
        }
        if questionHasBeenAnswered == true {
            if cell.collectionAnswerLabel.text == self.answer?.title {
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    self.correctAnswers.append(cell.collectionAnswerLabel.text)
                    cell.collectionAnswerLabel.textColor = UIColor.greenColor()
                    self.disableUserInteraction()
                    self.calculateScore()
                    self.questionTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "questionWasAnswered", userInfo: nil, repeats: false)
                    self.questionTimerTwo = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "displayQuestion:", userInfo: nil, repeats: false)
                })
            } else {
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    cell.collectionAnswerLabel.textColor = UIColor(red: 225/255, green: 1/255, blue: 20/255, alpha: 1.0)
                    self.disableUserInteraction()
                    self.showCorrectAnswer()
                    self.questionTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "questionWasAnswered", userInfo: nil, repeats: false)
                    self.questionTimerTwo = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "displayQuestion:", userInfo: nil, repeats: false)
                })
            }
        }
    }

    //MARK: UIInteractions
    
    func resetCollectionViewColor(cell: GameCollectionViewCell!) {
        cell.collectionAnswerLabel.textColor = UIColor.blackColor()
    }
    
    func disableUserInteraction() {
        self.collectionView.userInteractionEnabled = false
    }
    
    func enableUserInteraction() {
        self.collectionView.userInteractionEnabled = true
    }
    
    func resetViewController() {
        self.overviewTextView.text = ""
        self.timerLabel.hidden = true
        self.collectionView.hidden = true
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
