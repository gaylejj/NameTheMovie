//
//  GenreViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/11/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class GenreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GKGameCenterControllerDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var genres : [Genre] = Genre.genreFromPlist()
    var movies : [Movie]?
    
    let networkController = NetworkController()
    
    var gameCenterEnabled = false
    
    var genreImages = [UIImage]()
    
    var cell = GenreTableViewCell()
    
    var didAnimateCell: [NSIndexPath: Bool] = [:]
    
    let animationController = AnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileButton = UIBarButtonItem(title: "Profile", style: UIBarButtonItemStyle.Plain, target: self, action: "segueToProfileController")
        self.navigationItem.rightBarButtonItem = profileButton
        
        self.title = "Genres"
        
        self.createImagesArray()
        
        self.navigationController?.delegate = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("gameCenterEnabled"), name: appDelegate.kAuthenticationViewControllerFinished, object: nil)
        
        println(self.navigationController?.navigationBar.frame.height)

        
        // Do any additional setup after loading the view.
    }
    
    func gameCenterEnabledForPlayer() {
        println(GameCenterManager.sharedManager().localPlayerData())
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
        
        self.genreImages = [action, adventure, animation, comedy, crime, drama, fantasy, romance, sciFi, thriller]
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

        self.tableView.rowHeight = (self.tableView.frame.height - 64.0) / CGFloat(self.genres.count)
        println(self.tableView.rowHeight)

        
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
                    
                    if let string = errorDescription as String? {
                        
                        self.tableView.userInteractionEnabled = true
                        
                        let alertController = UIAlertController(title: "Error", message: "Something happened, we are very sorry. Please try again in a few minutes", preferredStyle: UIAlertControllerStyle.Alert)
                        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                    } else {
                        self.movies = movies
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            
                            self.performSegueWithIdentifier("Question", sender: self)
                        })
                    }
                    
                })
                
            }
    }
    
    func segueToProfileController() {

        if GameCenterManager.sharedManager().localPlayerData() != nil {
            GameCenterManager.sharedManager().presentLeaderboardsOnViewController(self)
            let leaderboardID = "com.jeff.PopcornQuizHighScore"
            println("High Scores: \(GameCenterManager.sharedManager().highScoreForLeaderboard(leaderboardID))")
        } else {
            let alertController = UIAlertController(title: "Game Center Unavailable", message: "Please go to Settings -> Game Center and sign in to enable this feature", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            
            let settingsAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                
                println("stuff")
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString))
                
            })
            
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }

    }

    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gameVC = segue.destinationViewController as GameViewController

        if segue.identifier == "Question" {

            gameVC.movies = self.movies

        }
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animationController
    }
    
    @IBAction func unwindToGenreVC(segue: UIStoryboardSegue!) {
        println("Pressing Play Again")
    }
}
