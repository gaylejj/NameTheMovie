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
    var networkController = NetworkController()
    
    var movies : [Movie]?
    
    var originalMovies : [Movie]?
    
    var genre : Genre?
    
    var score : Int?
        
    var answers = [Movie]() //Pass back to gameVC
    
    var delegate : GameLogicDelegate?
        
    func fetchQuestion() {
        let moviesCount = movies!.count - 1
        
        var randomIndex = Int(arc4random_uniform(UInt32(moviesCount)))
        
        let movieOne = movies![randomIndex]
        self.movies!.removeAtIndex(randomIndex)
        self.originalMovies!.removeAtIndex(randomIndex)
        
        networkController.fetchMovieForClick(movieOne, callback: { (movie, errorDescription) -> Void in
            if errorDescription != nil {
                println("Error occurred")
            } else {
                self.generateAnswersForGivenPlot(movie)
            }
        })
    }
    
    func generateAnswersForGivenPlot(movieForPlot : Movie) {
        let rightAnswer = movieForPlot
        var generatedAnswers = [Movie]()
        println("The right answer is \(rightAnswer.title)")
        generatedAnswers.append(rightAnswer)
    
        var numbers = [Int]()
        
        for i in 0..<self.originalMovies!.count {
            var num = i
            numbers.append(i)
        }
        for num in numbers {
            println("\(num) Title is \(self.originalMovies![num].title)")
        }
        
        //self.movies?.removeAtIndex(index)
        
        var randomIndex = Int(arc4random_uniform(UInt32(numbers.count)))
        
        let firstFalse = originalMovies![randomIndex]
        generatedAnswers.append(firstFalse)
        self.originalMovies!.removeAtIndex(randomIndex)
        println(firstFalse.title)
        
        numbers.removeAtIndex(randomIndex)
        
        var randomIndexTwo = Int(arc4random_uniform(UInt32(numbers.count)))
        
        let secondFalse = originalMovies![randomIndexTwo]
        generatedAnswers.append(secondFalse)
        self.originalMovies!.removeAtIndex(randomIndexTwo)
        println(secondFalse.title)
        
        numbers.removeAtIndex(randomIndexTwo)
        
        var randomIndexThree = Int(arc4random_uniform(UInt32(numbers.count)))
        
        let thirdFalse = originalMovies![randomIndexThree]
        generatedAnswers.append(thirdFalse)
        self.originalMovies!.removeAtIndex(randomIndexThree)
        println(thirdFalse.title)
        
        numbers.removeAtIndex(randomIndexThree)
        var question = Question()
        question.answers = generatedAnswers
        question.movie = rightAnswer
        println(self.answers.count)
        println(randomIndex)
        println(randomIndexTwo)
        println(randomIndexThree)
        
        self.originalMovies!.append(rightAnswer)
        self.originalMovies!.append(firstFalse)
        self.originalMovies!.append(secondFalse)
        self.originalMovies!.append(thirdFalse)
        for i in 0..<originalMovies!.count {
            var iarray = [Int]()
            iarray.append(i)
            for num in iarray {
                println(originalMovies![i].title)
            }
        }

        self.shuffleQuestionAnswers(question)
        
        
    }
    
    func shuffleQuestionAnswers(question: Question) {
        var finalQuestion = Question()
        finalQuestion.movie = question.movie
        
        var randomIndex = Int(arc4random_uniform(UInt32(3)))
        println(randomIndex)
        finalQuestion.answers.append(question.answers[randomIndex])
        question.answers.removeAtIndex(randomIndex)
        
         var randomIndexTwo = Int(arc4random_uniform(UInt32(2)))
        finalQuestion.answers.append(question.answers[randomIndexTwo])
        question.answers.removeAtIndex(randomIndexTwo)

        
         var randomIndexThree = Int(arc4random_uniform(UInt32(1)))
        finalQuestion.answers.append(question.answers[randomIndexThree])
        question.answers.removeAtIndex(randomIndexThree)
        
        finalQuestion.answers.append(question.answers[0])
    
        if self.delegate != nil {
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.delegate!.generatedQuestion(finalQuestion)
            }
        }
    }
    



    
}