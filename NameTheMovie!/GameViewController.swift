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
    
    let networkController = NetworkController()
    
    var gameLogic = GameLogic()
    
    var questions = [Question]()
    
    var gameStarted = false
    
    var questionsAnswered = 0
    
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var firstAnswerLabel: UILabel!
    @IBOutlet weak var secondAnswerLabel: UILabel!
    @IBOutlet weak var thirdAnswerLabel: UILabel!
    @IBOutlet weak var fourthAnswerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameLogic.delegate = self
        self.gameLogic.movies = self.movies!
        self.gameLogic.originalMovies = self.movies!
        self.gameLogic.networkController = self.networkController
        self.overviewTextView.scrollEnabled = true
        self.gameLogic.fetchQuestion()
        self.gameLogic.fetchQuestion()
        
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
        } else {
            println("Already a question there")
        }
        println(question.movie?.title)
        println("Generated Question Overview is \(question.movie?.overview)")

    }
    
    func displayQuestion() {
        //Text labels for index 0
        let question = questions[0]
//        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.overviewTextView.text = question.movie?.overview
            self.firstAnswerLabel.text = question.answers[0].title
            self.secondAnswerLabel.text = question.answers[1].title
            self.thirdAnswerLabel.text = question.answers[2].title
            self.fourthAnswerLabel.text = question.answers[3].title
            self.questions.removeAtIndex(0)

            println("Question displayed")
//        }

    }

    @IBAction func nextQuestion(sender: AnyObject) {
        self.displayQuestion()
        self.questionWasAnswered()
    }
    
    func questionWasAnswered() {
        self.questionsAnswered++
        if self.questions.count - self.questionsAnswered <= 2 {
            self.gameLogic.fetchQuestion()
        }
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
