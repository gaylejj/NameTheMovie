//
//  AnswersViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/15/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score : Double?
    
    var nf = NSNumberFormatter()
    
    var playerAnswers = [String]()
    var correctAnswers = [Movie]()
    
    var genre : Genre!
    var movies = [Movie]()
    
    let networkController = NetworkController()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for answer in self.playerAnswers {
            println(answer)
        }
        
        for otherAnswer in self.correctAnswers {
            println("Correct \(otherAnswer)")
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.tableView.reloadData()
//        self.collectionView.reloadData()
        self.nf.maximumFractionDigits = 0
        self.collectionView.backgroundColor = UIColor(red: 51/255, green: 77/255, blue: 93/255, alpha: 1.0)

//        self.scoreLabel.text = "Score: \(self.nf.stringFromNumber(self.score!))"
//        self.scoreLabel.adjustsFontSizeToFitWidth = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("answerCell", forIndexPath: indexPath) as AnswerTableViewCell

        let correctAnswer = self.correctAnswers[indexPath.row]
        let playerAnswer = self.playerAnswers[indexPath.row]
            
        cell.correctAnswerLabel.text = correctAnswer.title
        println("\(correctAnswer.poster_path)")
        cell.playerAnswerLabel.text = playerAnswer
        
        cell.playerAnswerLabel.numberOfLines = 0
        cell.correctAnswerLabel.numberOfLines = 0
            
        cell.correctAnswerLabel.adjustsFontSizeToFitWidth = true
        cell.playerAnswerLabel.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.correctAnswers.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.correctAnswers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("answerCell", forIndexPath: indexPath) as AnswerCollectionViewCell
        
        let correctAnswer = self.correctAnswers[indexPath.row]
        
        cell.correctAnswerLabel.text = correctAnswer.title
        cell.correctAnswerLabel.adjustsFontSizeToFitWidth = true
        
        let poster = self.networkController.loadMoviePosterForCorrectAnswer(correctAnswer.poster_path!)
        
        cell.posterImageView.image = poster
        
        return cell
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
