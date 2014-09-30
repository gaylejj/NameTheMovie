//
//  GameLogic.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/12/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import Foundation

protocol GameLogicDelegate {
    func generatedQuestion(question: Question)
    //Call when ready, then call in gameVC
}

class GameLogic: NSObject {
    //MARK: Properties
    var networkController = NetworkController()
    
    var movies : [Movie]?
    
    var originalMovies : [Movie]?
    
    var genre : Genre?
    
    var score : Int?
        
    var answers = [Movie]() //Pass back to gameVC
    
    var delegate : GameLogicDelegate?
    
    //MARK: Game Functions
    //Create question
    func fetchQuestion() {
        let moviesCount = movies!.count - 1
        
        var randomIndex = Int(arc4random_uniform(UInt32(moviesCount)))
        
        let movieOne = movies![randomIndex]
        self.movies!.removeAtIndex(randomIndex)
        self.originalMovies!.removeAtIndex(randomIndex)
        
        let movieQ = NSOperationQueue()
        
        movieQ.addOperationWithBlock { () -> Void in
            self.networkController.fetchMovieForGame(movieOne, callback: { (movie, errorDescription) -> Void in
                if errorDescription != nil {
                    
                } else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.generateAnswersForGivenPlot(movie)
                    })
                }
            })

        }
    }
    
    //Create 3 incorrect answers from list generated with genre call
    func generateAnswersForGivenPlot(movieForPlot : Movie) {
        let rightAnswer = movieForPlot
        var generatedAnswers = [Movie]()
        generatedAnswers.append(rightAnswer)
    
        var numbers = [Int]()
        
        for i in 0..<self.originalMovies!.count {
            var num = i
            numbers.append(i)
        }
        
        //Find 3 answers that don't match each other or movie title
        var i = 0
        while i < 3 {
            var incorrectAnswer = self.returnRandomAnswer(numbers, rightAnswer: rightAnswer)
            for answer in generatedAnswers {
                if incorrectAnswer.title == answer.title {
                    incorrectAnswer = self.returnRandomAnswer(numbers, rightAnswer: rightAnswer)
                }
            }
            generatedAnswers.append(incorrectAnswer)
            i++
        }
        
        var question = Question()
        question.answers = generatedAnswers
        question.movie = rightAnswer
        
        self.shuffleQuestionAnswers(question)
    }
    
    //Get random answer from array
    func returnRandomAnswer(numbers: [Int], rightAnswer: Movie) -> Movie {
        
        var randomIndex = Int(arc4random_uniform(UInt32(numbers.count)))
        
        let firstFalse = originalMovies![randomIndex]
        //Check that false answer doesn't match correct answer
        if firstFalse.title == rightAnswer.title {
            return self.returnRandomAnswer(numbers, rightAnswer: rightAnswer)
        } else {
//            self.originalMovies!.removeAtIndex(randomIndex)
            return firstFalse
        }
    }
    
    //Shuffle correct/incorrect answers so correct isn't always first in line
    func shuffleQuestionAnswers(question: Question) {
        var finalQuestion = Question()
        finalQuestion.movie = question.movie
        
        var randomIndex = Int(arc4random_uniform(UInt32(3)))
        finalQuestion.answers.append(question.answers[randomIndex])
        question.answers.removeAtIndex(randomIndex)
        
         var randomIndexTwo = Int(arc4random_uniform(UInt32(2)))
        finalQuestion.answers.append(question.answers[randomIndexTwo])
        question.answers.removeAtIndex(randomIndexTwo)

        
         var randomIndexThree = Int(arc4random_uniform(UInt32(1)))
        finalQuestion.answers.append(question.answers[randomIndexThree])
        question.answers.removeAtIndex(randomIndexThree)
        
        finalQuestion.answers.append(question.answers[0])
    
        //Send question to delegate call
        if self.delegate != nil {
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.delegate!.generatedQuestion(finalQuestion)
            }
        }
    }
}