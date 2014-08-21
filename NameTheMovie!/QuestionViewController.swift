//
//  QuestionViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/19/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

protocol QuestionViewControllerDelegate {
    func questionAnswered(correctAnswer: String, playerAnswer: String)
}

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var timerIsRunning = false
    var questionHasBeenAnswered = false
    var gameTime = 13.0
    
    var question : Question?
    var answer : Movie?
    
    var delegate : QuestionViewControllerDelegate?
    
    let gameVC : GameViewController?
    let timerVC = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        self.overviewTextView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestionInVC(question: Question) {
        self.tableView.userInteractionEnabled = false
        self.question = question
        self.answer = question.movie
        self.tableView.reloadData()
        self.view.hidden = false
        self.overviewTextView.text = self.answer?.overview
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }) { (Bool) -> Void in
            self.tableView.userInteractionEnabled = true
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

        if self.timerVC.timerIsRunning == true {
            timerVC.stopTimer()
        }
        if self.questionHasBeenAnswered == true {
            if cell.shownQuestionLabel.text == self.answer?.title {
                self.correctAnswerAnimation(indexPath)
            } else {
                self.incorrectAnswerAnimation(indexPath)
            }
        }
        
        self.delegate?.questionAnswered(self.answer!.title!, playerAnswer: (self.tableView.cellForRowAtIndexPath(indexPath) as QuestionTableViewCell).shownQuestionLabel.text)
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
                
//                if gameVC!.questionHasBeenAnswered == false {
//                    gameVC!.playerAnswers.append("___")
//                    gameVC!.questionTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "questionWasAnswered", userInfo: nil, repeats: false)
//                    gameVC!.questionTimerTwo = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "displayQuestion:", userInfo: nil, repeats: false)
//                }
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
}

