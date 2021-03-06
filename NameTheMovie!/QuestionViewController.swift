//
//  QuestionViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/19/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit
import QuartzCore

protocol QuestionViewControllerDelegate {
    func questionAnswered(correctAnswer: Movie, playerAnswer: String, timeScore: Double)
}

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: Properties/Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var overViewTextHeight: NSLayoutConstraint!
    @IBOutlet weak var timerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var overViewTextTopHeight: NSLayoutConstraint!
    
    var timerIsRunning = false
    var questionHasBeenAnswered = false
    var gameTime = 13.0
    var timeScore = 0.0
    
    var timerLabelTimer : NSTimer!
    
    var question : Question?
    var answer : Movie?
    
    var delegate : QuestionViewControllerDelegate?
    
    let gameVC : GameViewController?
    let nf = NSNumberFormatter()
    let scoreNF = NSNumberFormatter()
    
    //MARK: Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        self.overviewTextView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 1
        
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
        case .OrderedSame, .OrderedDescending:
            println("iOS >= 8.0")
            self.overViewTextTopHeight.constant = 8
            if self.view.frame.height == 480 {
                self.tableViewHeight.constant = CGFloat(160.0)
                self.overViewTextHeight.constant = 215
            } else if self.view.frame.height == 568 {
                self.tableViewHeight.constant = CGFloat(210.0)
            } else if self.view.frame.height == 667 {
                self.tableViewHeight.constant = CGFloat(260.0)
                self.overViewTextHeight.constant = CGFloat(300)
                self.overviewTextView.font = UIFont(name: "Avenir", size: 18.0)
            } else if self.view.frame.height == 736 {
                self.tableViewHeight.constant = CGFloat(260.0)
                self.overViewTextHeight.constant = CGFloat(350)
                self.overviewTextView.font = UIFont(name: "Avenir", size: 18.0)
            }
            
        case .OrderedAscending:
            self.overViewTextTopHeight.constant = 46
            if self.view.frame.height == 480 {
                self.tableViewHeight.constant = CGFloat(160.0)
                self.overViewTextHeight.constant = 215
                
            } else if self.view.frame.height == 568 {
                self.tableViewHeight.constant = CGFloat(210.0)
                
            }
            self.tableView.setNeedsUpdateConstraints()
            self.overviewTextView.setNeedsUpdateConstraints()
            self.timerLabel.setNeedsUpdateConstraints()
        }

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Display quesiton on questionVC
    func displayQuestionInVC(question: Question) {
        self.gameTime = 13.0
        self.timeScore = 0.0
        self.tableView.userInteractionEnabled = false
        self.questionHasBeenAnswered = false
        self.question = question
        self.answer = question.movie
        self.tableView.reloadData()
        self.view.hidden = false
        
        //Create overview without movie title in it
        var overview = "\(self.answer!.overview!)"
        let newOverview = overview.stringByReplacingOccurrencesOfString(question.movie!.title!, withString: "________", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        self.overviewTextView.text = newOverview

        //Change font size depending on length of overview
        if self.overviewTextView.contentSize.height > (1.5 * self.overviewTextView.frame.size.height)
        {
            self.overviewTextView.font = UIFont(name: "Avenir", size: 14.0)
        } else {
            self.overviewTextView.font = UIFont(name: "Avenir", size: 16.0)
        }
        
        //Overview characteristics
        self.overviewTextView.textColor = UIColor(red: 234/255, green: 190/255, blue: 58/255, alpha: 1.0)
        self.overviewTextView.selectable = false

        //TimerLabel characteristics
        self.timerLabel.text = "\(self.gameTime)"
        self.timerLabel.font = UIFont(name: "Avenir", size: 18.0)
        self.timerLabel.textColor = UIColor(red: 234/255, green: 190/255, blue: 58/255, alpha: 1.0)
        
        //Animate questionVC into frame for player
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        }) { (finished) in
            //Start timer
            self.tableView.userInteractionEnabled = true
            self.startTimer()
            self.timerLabel.text = "\(self.gameTime)"
            
            if finished {
                //Start plot scrolling
                self.startPlotScrolling()
            }
        }
    }
    
    //MARK: Tableivew functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if question == nil {
            return 0
        } else {
            return self.question!.answers.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = CGFloat(65)
        if self.view.frame.height == 480 {
            height = 40
        } else if self.view.frame.height == 568 {
            height = 52.5
        }
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath) as QuestionTableViewCell
        
        self.resetTableView(cell)
        
        //Offset overview to point 0,0
        self.overviewTextView.setContentOffset(CGPointZero, animated: false)
        
        //Change tableview height/row height, or overview height based on device size
//        if self.view.frame.height == 480 {
//            self.tableViewHeight.constant = CGFloat(160.0)
//            self.tableView.rowHeight = 40
//            self.overViewTextHeight.constant = 215
//        } else if self.view.frame.height == 568 {
//            self.tableViewHeight.constant = CGFloat(210.0)
//            self.tableView.rowHeight = 52.5
//        } else if self.view.frame.height == 667 {
//            self.overViewTextHeight.constant = CGFloat(300)
//            self.overviewTextView.font = UIFont(name: "Avenir", size: 18.0)
//        } else if self.view.frame.height == 736 {
//            self.overViewTextHeight.constant = CGFloat(350)
//            self.overviewTextView.font = UIFont(name: "Avenir", size: 18.0)
//        }
        
        
        //setting up cell
        cell.shownQuestionLabel.text = self.question!.answers[indexPath.row].title
        cell.shownQuestionLabel.adjustsFontSizeToFitWidth = true
        cell.shownQuestionLabel.textColor = UIColor.lightGrayColor()

        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as QuestionTableViewCell
        self.questionHasBeenAnswered = true
        
        //stop timer
        if self.timerIsRunning == true {
            self.stopTimer()
        }
        
        //Check answer based on cell selected
        if self.questionHasBeenAnswered == true {
            if cell.shownQuestionLabel.text == self.answer?.title {
                self.correctAnswerAnimation(indexPath)
                self.timeScore = self.gameTime
            } else {
                self.incorrectAnswerAnimation(indexPath)
                self.timeScore = 0
            }
        }
        
        //Call delegate
        self.delegate?.questionAnswered(self.answer!, playerAnswer: (self.tableView.cellForRowAtIndexPath(indexPath) as QuestionTableViewCell).shownQuestionLabel.text!, timeScore: self.timeScore)
    }
    
    //MARK: Answer functions
    //Called if timer runs out
    func showCorrectAnswer() {
        
        var indexPaths : [NSIndexPath]? = tableView.indexPathsForVisibleRows() as [NSIndexPath]?
        
        for indexPath in indexPaths! {
            self.tableView.userInteractionEnabled = false
            
            let cell = tableView.cellForRowAtIndexPath(indexPath as NSIndexPath) as QuestionTableViewCell
            
            if cell.shownQuestionLabel.text == self.answer?.title {
                UIView.animateWithDuration(0.0, animations: { () -> Void in
                    cell.shownQuestionLabel.textColor = UIColor.greenColor()
                })
                
                if self.questionHasBeenAnswered == false {
                    self.delegate?.questionAnswered(self.answer!, playerAnswer: "_____", timeScore: self.gameTime)
                }
            }
        }
    }
    
    //Animate correct answer
    func correctAnswerAnimation(indexPath : NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as QuestionTableViewCell
        
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            cell.shownQuestionLabel.textColor = UIColor.greenColor()
            self.tableView.userInteractionEnabled = false
        })
    }
    
    //Animate incorrect answer
    func incorrectAnswerAnimation(indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as QuestionTableViewCell
        
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            cell.shownQuestionLabel.textColor = UIColor(red: 225/255, green: 1/255, blue: 20/255, alpha: 1.0)
            self.tableView.userInteractionEnabled = false
            self.showCorrectAnswer()
        })
    }
    
    func resetTableView(cell: QuestionTableViewCell!) {
        cell.shownQuestionLabel.textColor = UIColor.lightGrayColor()
    }
    
    func startPlotScrolling() {
        //If overview is larger than the textview height, scroll
        if self.overviewTextView.contentSize.height > self.overviewTextView.frame.size.height {
            UIView.animateWithDuration(6.5, delay: 1.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in

                //Set offset to section not shown initially
                var initialOffset = self.overviewTextView.contentSize.height - self.overviewTextView.frame.size.height
                
                self.overviewTextView.setContentOffset(CGPoint(x: 0, y: initialOffset), animated: false)
                
                }) { (finished) -> Void in
            }
        }
    }
    
    //MARK: Timer Setup
    func startTimer() {
        self.timerIsRunning = true
        timerLabelTimer = NSTimer.scheduledTimerWithTimeInterval(0.10, target: self, selector:"subtractTime", userInfo: nil, repeats: true)
    }

    func stopTimer() {
        self.timerIsRunning = false
        timerLabelTimer.invalidate()
    }
    
    func subtractTime() {
        if self.gameTime < 5.0 {
            self.timerLabel.font = UIFont(name: "Avenir", size: 48.0)
        }
        if self.gameTime > 0.1 {
            var timeLeft = self.gameTime - 0.10
            self.gameTime = timeLeft
            self.timerLabel.text = "\(self.nf.stringFromNumber(self.gameTime)!)"
        } else {
            self.stopTimer()
            self.showCorrectAnswer()
        }
    }
}

