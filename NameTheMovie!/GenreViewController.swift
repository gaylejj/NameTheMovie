//
//  GenreViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/11/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class GenreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GKGameCenterControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var genres : [Genre] = Genre.genreFromPlist()
    var movies : [Movie]?
    
    let networkController = NetworkController()
    
    var gameCenterEnabled = false
    
    var genreImages = [UIImage]()
    
    var cell = GenreTableViewCell()
    
    var didAnimateCell: [NSIndexPath: Bool] = [:]
    
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileButton = UIBarButtonItem(title: "Profile", style: UIBarButtonItemStyle.Plain, target: self, action: "segueToProfileController")
        self.navigationItem.rightBarButtonItem = profileButton
        
        self.title = "Genres"
        
        self.createImagesArray()
        
        
        // Do any additional setup after loading the view.
    }
    
    func createImagesArray() {
        var action = UIImage(named: "action.png")
        var adventure = UIImage(named: "adventure.png")
        var animation = UIImage(named: "realanimation.png")
        var comedy = UIImage(named: "comedy.png")
        var crime = UIImage(named: "crime.png")
        var drama = UIImage(named: "drama.png")
        var fantasy = UIImage(named: "fantasy.png")
        var romance = UIImage(named: "romcom.png")
        var sciFi = UIImage(named: "scifi.png")
        var thriller = UIImage(named: "thriller.png")
        var western = UIImage(named: "western.png")
        
        self.genreImages = [action, adventure, animation, comedy, crime, drama, fantasy, romance, sciFi, thriller, western]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.userInteractionEnabled = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.cell = tableView.dequeueReusableCellWithIdentifier("GenreCell", forIndexPath: indexPath) as GenreTableViewCell
        
        let genre = self.genres[indexPath.row]
        let image = self.genreImages[indexPath.row]
            
        self.cell.genreTitleLabel.text = genre.name
        self.cell.genreImageView.image = image
        
        if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
            self.tableView.rowHeight = 41.0
        }
        
        self.tableView.scrollEnabled = false


        return self.cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.didAnimateCell[indexPath] == nil || self.didAnimateCell[indexPath] == false {
            self.didAnimateCell[indexPath] = true
            if let genreCell = cell as? GenreTableViewCell {
                CellAnimator.animate(genreCell)
            }
        }


    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.tableView.userInteractionEnabled = false
        
        let gameVC = self.storyboard!.instantiateViewControllerWithIdentifier("Game") as GameViewController
        
        let genre = genres[indexPath.row]
        gameVC.genre = genre
        
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.networkController.discoverMovie(genre, callback: { (movies, errorDescription) -> Void in
                    self.movies = movies
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
         
                        self.performSegueWithIdentifier("Question", sender: self)
                    })
                })
                
            }
    }
    
    func segueToProfileController() {

        GameCenterManager.sharedManager().presentLeaderboardsOnViewController(self)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Question" {
            let gameVC = segue.destinationViewController as GameViewController
                
            gameVC.movies = self.movies

            gameVC.transitioningDelegate = self.transitionManager
        }
    }
    
    @IBAction func unwindToGenreVC(segue: UIStoryboardSegue!) {
        println("Pressing Play Again")
    }
}
