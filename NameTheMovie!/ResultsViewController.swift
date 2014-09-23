//
//  AnswersViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/15/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UICollectionViewDataSource, UINavigationBarDelegate, UIBarPositioningDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score : Double?
    
    var nf = NSNumberFormatter()
    
    var playerAnswers = [String]()
    var correctAnswers = [Movie]()
    
    var genre : Genre!
    var movies = [Movie]()
    
    var imageQueue = NSOperationQueue()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
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
        self.nf.maximumFractionDigits = 0
        self.view.backgroundColor = UIColor(red: 51/255, green: 77/255, blue: 93/255, alpha: 1.0)
        self.collectionView.backgroundColor = UIColor(red: 51/255, green: 77/255, blue: 93/255, alpha: 1.0)
        
        self.scoreLabel.textColor = UIColor(red: 234/255, green: 190/255, blue: 58/255, alpha: 1.0)
        self.scoreLabel.text = "Score: \(self.nf.stringFromNumber(self.score!))"
        self.scoreLabel.adjustsFontSizeToFitWidth = true

    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Deprecated TableView Methods
    /*
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
    */
    
    //MARK: CollectionView Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.correctAnswers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("answerCell", forIndexPath: indexPath) as AnswerCollectionViewCell
        
        if self.view.frame.height <= 568 {
            cell.posterImageView.frame.size = CGSize(width: 90, height: 135)
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: 90, height: 155)
                cell.correctAnswerLabel.frame.size = CGSize(width: 90, height: 30)
                cell.correctAnswerLabel.adjustsFontSizeToFitWidth = true
            }
            println(cell.posterImageView.frame.size)
        } else {
            cell.posterImageView.frame.size = CGSize(width: 120, height: 150)
            cell.correctAnswerLabel.frame.size = CGSize(width: 120, height: 30)
            println(cell.posterImageView.frame.size)
        }
        
        let correctAnswer = self.correctAnswers[indexPath.row]
        
        cell.correctAnswerLabel.text = correctAnswer.title
        cell.correctAnswerLabel.adjustsFontSizeToFitWidth = true
        cell.correctAnswerLabel.numberOfLines = 1
        cell.correctAnswerLabel.minimumScaleFactor = 0.5
        
        self.loadMoviePosterForCorrectAnswer(correctAnswer.poster_path!, completion: { (poster) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                cell.posterImageView.image = poster
            })
        })
        
        return cell
    }
    
    func loadMoviePosterForCorrectAnswer(posterPath: String?, completion: (poster: UIImage) -> Void) {
        
        self.imageQueue.addOperationWithBlock { () -> Void in
            var prefix = ""
            if self.view.frame.height > 568 {
                prefix = "http://image.tmdb.org/t/p/w130"
                println("Getting W130 picture")
            } else {
                println("Getting W90 picture")
                prefix = "http://image.tmdb.org/t/p/w90"
            }
            //TODO: 4s/5s layout constraints
            //Use w90 for 4s/5s phones. 90x135 image, so change height layout constraint to 135, width of imageview to 90, height of cell to 155
            let urlString = prefix + "\(posterPath!)"
            let url = NSURL(string: urlString)
            let imgData = NSData(contentsOfURL: url)
            let posterImage = UIImage(data: imgData)
            completion(poster: posterImage)
            
        }
        
    }

}
