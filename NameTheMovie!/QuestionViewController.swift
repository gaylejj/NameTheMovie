//
//  QuestionViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/19/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

protocol QuestionViewControllerDelegate {
    func questionAnswered(correctAnswer: String, playerAnswer: String, timeScore: Double)
}

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    @IBOutlet weak var timerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        self.overviewTextView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 1
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestionInVC(question: Question) {
        self.gameTime = 13.0
        self.timeScore = 0.0
        self.tableView.userInteractionEnabled = false
        self.question = question
        self.answer = question.movie
        self.tableView.reloadData()
        self.view.hidden = false
        
        var overview = "\(self.answer!.overview!)"
        let newOverview = overview.stringByReplacingOccurrencesOfString(question.movie!.title!, withString: "________", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        self.overviewTextView.text = newOverview

        self.timerLabel.text = "\(self.gameTime)"
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }) { (Bool) -> Void in
            self.tableView.userInteractionEnabled = true
            self.startTimer()
            self.timerLabel.text = "\(self.gameTime)"
        }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if question == nil {
            return 0
        } else {
            return self.question!.answers.count
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath) as QuestionTableViewCell
        
        self.resetTableView(cell)
        cell.shownQuestionLabel.text = self.question!.answers[indexPath.row].title
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as QuestionTableViewCell
        self.questionHasBeenAnswered = true
        
        if self.timerIsRunning == true {
            self.stopTimer()
        }
        if self.questionHasBeenAnswered == true {
            if cell.shownQuestionLabel.text == self.answer?.title {
                self.correctAnswerAnimation(indexPath)
                self.timeScore = self.gameTime
            } else {
                self.incorrectAnswerAnimation(indexPath)
                self.timeScore = 0
            }
        }
        self.delegate?.questionAnswered(self.answer!.title!, playerAnswer: (self.tableView.cellForRowAtIndexPath(indexPath) as QuestionTableViewCell).shownQuestionLabel.text, timeScore: self.timeScore)
    }
    
    func showCorrectAnswer() {
        
        var indexPaths = tableView.indexPathsForVisibleRows()
        
        for indexPath in indexPaths {
            self.tableView.userInteractionEnabled = false
            
            let cell = tableView.cellForRowAtIndexPath(indexPath as NSIndexPath) as QuestionTableViewCell
            
            if cell.shownQuestionLabel.text == self.answer?.title {
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    cell.shownQuestionLabel.textColor = UIColor.greenColor()
                })
                
                if self.questionHasBeenAnswered == false {
                    self.delegate?.questionAnswered(self.answer!.title!, playerAnswer: "_____", timeScore: self.gameTime)
                }
            }
        }
    }
    
    func correctAnswerAnimation(indexPath : NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as QuestionTableViewCell
        
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            cell.shownQuestionLabel.textColor = UIColor.greenColor()
            self.tableView.userInteractionEnabled = false
        })
    }
    
    func incorrectAnswerAnimation(indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as QuestionTableViewCell
        
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            cell.shownQuestionLabel.textColor = UIColor(red: 225/255, green: 1/255, blue: 20/255, alpha: 1.0)
            self.tableView.userInteractionEnabled = false
            self.showCorrectAnswer()
        })
    }
    
    func resetTableView(cell: QuestionTableViewCell!) {
        cell.shownQuestionLabel.textColor = UIColor.blackColor()
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
}

