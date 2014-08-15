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
    
    let networkController = NetworkController()
    
    var gameLogic = GameLogic()
    
    var questions = [Question]()
    
    var gameStarted = false
    
    var questionsAnswered = 0
    
    var score = 0.0
    
    var gameTime = 10.0
    
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
    
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet weak var thirdButton: UIButton!
    
    @IBOutlet weak var fourthButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView : UICollectionView!
        
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
        
        self.firstButton.titleLabel.numberOfLines = 0
        self.secondButton.titleLabel.numberOfLines = 0
        self.thirdButton.titleLabel.numberOfLines = 0
        self.fourthButton.titleLabel.numberOfLines = 0
        
        self.firstButton.hidden = true
        self.secondButton.hidden = true
        self.thirdButton.hidden = true
        self.fourthButton.hidden = true

        
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
            self.gameStarted = true
            self.displayQuestion(self.questionsAnswered)
        }
    }
    
    func displayQuestion(questionsAnswered: Int) {
        if self.questionsAnswered < 5 {
            self.gameTime = 12.0
            let question = questions[self.questionsAnswered]
            self.answer = question.movie
            
            println("Display question \(self.gameStarted)")
            var overview = "\(question.movie!.overview!)"
            let newOverview = overview.stringByReplacingOccurrencesOfString(question.movie!.title!, withString: "________", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
            
            self.overviewTextView.text = newOverview
            
            self.resetButtonTitleColor()
            
//            self.firstButton.setTitle(question.answers[0].title, forState: UIControlState.Normal)
//            
//            self.secondButton.setTitle(question.answers[1].title, forState: UIControlState.Normal)
//            self.thirdButton.setTitle(question.answers[2].title, forState: UIControlState.Normal)
//            self.fourthButton.setTitle(question.answers[3].title, forState: UIControlState.Normal)
            
            
            self.enableUserInteraction()
            self.questionHasBeenAnswered = false
            
            println("Question displayed")
            self.timerLabel.text = "\(self.gameTime)"
            self.collectionView.reloadData()
            if self.questionHasBeenAnswered == false {
                self.beginningTimer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "startTimer", userInfo: nil, repeats: false)
            }
//            self.scoreTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateTime", userInfo: nil, repeats: true)

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

    @IBAction func nextQuestion(sender: UIButton!) {
        println(sender.currentTitle)
        self.questionHasBeenAnswered = true
        if self.timerIsRunning == true {
            self.stopTimer()
        }
        if sender.currentTitle {
            if sender.currentTitle == self.answer?.title {
//                self.score++
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    sender.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                    self.disableUserInteraction()
                    self.calculateScore()
                    self.questionTimer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "questionWasAnswered", userInfo: nil, repeats: false)
                    self.questionTimerTwo = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "displayQuestion:", userInfo: nil, repeats: false)
                })
            } else {
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    sender.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                    self.disableUserInteraction()
                    self.questionTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "questionWasAnswered", userInfo: nil, repeats: false)
                    self.questionTimerTwo = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "displayQuestion:", userInfo: nil, repeats: false)
                })
            }
        }
    }
    
    func displayScore() {
        self.disableUserInteraction()
        
        var scoreAlert = UIAlertAction(title: "Score was \(self.scoreNF.stringFromNumber(self.score))", style: UIAlertActionStyle.Default, handler: nil)
        
        self.alertView.addAction(scoreAlert)
        self.resetViewController()

        self.presentViewController(self.alertView, animated: true) { () -> Void in
//            self.reportScoreToGameCenter()
        }
    }
    
    //MARK: Timer Setup
    func startTimer() {
        self.timerIsRunning = true
        timerLabelTimer = NSTimer.scheduledTimerWithTimeInterval(0.10, target: self, selector: "subtractTime", userInfo: nil, repeats: true)
        println(self.gameTime)
    }
    
    func stopTimer() {
        self.timerIsRunning = false
        timerLabelTimer.invalidate()
        println(self.gameTime)
    }
    
    func subtractTime() {
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
            println(self.nf.stringFromNumber(self.score))
        }
    }
    
    func showCorrectAnswer() {
        var buttons = [UIButton]()
        buttons.append(self.firstButton)
        buttons.append(self.secondButton)
        buttons.append(self.thirdButton)
        buttons.append(self.fourthButton)
        
        for button in buttons {
            self.disableUserInteraction()
            
            if button.currentTitle == self.answer?.title {
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    button.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                })
                
                self.questionTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "questionWasAnswered", userInfo: nil, repeats: false)
                self.questionTimerTwo = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "displayQuestion:", userInfo: nil, repeats: false)
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("answer", forIndexPath: indexPath) as AnswerCollectionViewCell
        
        let question = self.questions[self.questionsAnswered]
        self.resetCollectionViewColor(cell)
        
        cell.collectionAnswerLabel.text = question.answers[indexPath.row].title
        if cell != nil {
            cell.collectionAnswerLabel.numberOfLines = 0
        }

        println(cell.frame)
        
        return cell
    }
    
    //MARK: UICollectionView Delegate
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        self.questionHasBeenAnswered = true

        if self.timerIsRunning == true {
            self.stopTimer()
        }
        if questionHasBeenAnswered == true {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as AnswerCollectionViewCell
            if cell.collectionAnswerLabel.text == self.answer?.title {
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    cell.collectionAnswerLabel.textColor = UIColor.greenColor()
                    self.disableUserInteraction()
                    self.calculateScore()
                    self.questionTimer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "questionWasAnswered", userInfo: nil, repeats: false)
                    self.questionTimerTwo = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "displayQuestion:", userInfo: nil, repeats: false)
                })
            } else {
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    cell.collectionAnswerLabel.textColor = UIColor.redColor()
                    self.disableUserInteraction()
                    self.questionTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "questionWasAnswered", userInfo: nil, repeats: false)
                    self.questionTimerTwo = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "displayQuestion:", userInfo: nil, repeats: false)
                })
            }
        }
    }

    //MARK: UIInteractions
    func resetButtonTitleColor() {
        self.firstButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.secondButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.thirdButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.fourthButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    }
    
    func resetCollectionViewColor(cell: AnswerCollectionViewCell!) {
        cell.collectionAnswerLabel.textColor = UIColor.blackColor()
    }
    
    func disableUserInteraction() {
        self.firstButton.userInteractionEnabled = false
        self.secondButton.userInteractionEnabled = false
        self.thirdButton.userInteractionEnabled = false
        self.fourthButton.userInteractionEnabled = false
        self.collectionView.userInteractionEnabled = false
    }
    
    func enableUserInteraction() {
        self.firstButton.userInteractionEnabled = true
        self.secondButton.userInteractionEnabled = true
        self.thirdButton.userInteractionEnabled = true
        self.fourthButton.userInteractionEnabled = true
        self.collectionView.userInteractionEnabled = true
    }
    
    func resetViewController() {
        self.overviewTextView.text = ""
        self.firstButton.setTitle("", forState: UIControlState.Normal)
        self.secondButton.setTitle("", forState: UIControlState.Normal)
        self.thirdButton.setTitle("", forState: UIControlState.Normal)
        self.fourthButton.setTitle("", forState: UIControlState.Normal)
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
