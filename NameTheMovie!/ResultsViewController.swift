//
//  AnswersViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/15/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UICollectionViewDataSource, UINavigationBarDelegate, UIBarPositioningDelegate {

    //MARK: Properties/Outlets
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
    
    //MARK: Loading functions
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //Position bar as normal navigation bar
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: CollectionView Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.correctAnswers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("answerCell", forIndexPath: indexPath) as AnswerCollectionViewCell
        
        //Adjust image for 5s/4s devices
        if self.view.frame.height <= 568 {
            cell.posterImageView.frame.size = CGSize(width: 90, height: 135)
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: 90, height: 155)
                cell.correctAnswerLabel.frame.size = CGSize(width: 90, height: 30)
                cell.correctAnswerLabel.adjustsFontSizeToFitWidth = true
            }
        } else {
            cell.posterImageView.frame.size = CGSize(width: 120, height: 150)
            cell.correctAnswerLabel.frame.size = CGSize(width: 120, height: 30)
        }
        
        //Setup cell
        let correctAnswer = self.correctAnswers[indexPath.row]
        cell.correctAnswerLabel.text = correctAnswer.title
        cell.correctAnswerLabel.adjustsFontSizeToFitWidth = true
        cell.correctAnswerLabel.numberOfLines = 1
        cell.correctAnswerLabel.minimumScaleFactor = 0.5
        
        //Load movie posters
        self.loadMoviePosterForCorrectAnswer(correctAnswer.poster_path!, completion: { (poster) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                cell.posterImageView.image = poster
            })
        })
        
        return cell
    }
    
    //MARK: Load movie posters
    func loadMoviePosterForCorrectAnswer(posterPath: String?, completion: (poster: UIImage) -> Void) {
        
        self.imageQueue.addOperationWithBlock { () -> Void in
            var prefix = ""
            if self.view.frame.height > 568 {
                prefix = "http://image.tmdb.org/t/p/w130"
            } else {
                prefix = "http://image.tmdb.org/t/p/w90"
            }
            
            let urlString = prefix + "\(posterPath!)"
            let url = NSURL(string: urlString)
            let imgData = NSData(contentsOfURL: url)
            let posterImage = UIImage(data: imgData)
            completion(poster: posterImage)
        }
    }
}
