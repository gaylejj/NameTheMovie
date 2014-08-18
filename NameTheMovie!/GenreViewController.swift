//
//  GenreViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/11/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class GenreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var genres : [Genre] = Genre.genreFromPlist()
    var movies : [Movie]?
    var rainbowColors = RainbowColors.colorsFromPlist()
    
    let networkController = NetworkController()
    let gamekitHelper = GameKitHelper()
    
    var gameCenterEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileButton = UIBarButtonItem(title: "Profile", style: UIBarButtonItemStyle.Plain, target: self, action: "segueToProfileController")
        self.navigationItem.rightBarButtonItem = profileButton
        
        // Do any additional setup after loading the view.
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
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("GenreCell", forIndexPath: indexPath) as GenreTableViewCell
        
        let genre = self.genres[indexPath.row]
        
        let color = self.rainbowColors[indexPath.row]
        println("R: \(color.r) G: \(color.g) B: \(color.b) A: \(color.a)")
        cell.backgroundColor = UIColor(red: color.r/255, green: color.g/255, blue: color.b/255, alpha: color.a)
        
        cell.genreTitleLabel.text = genre.name
        
        if indexPath.row < 5 {
            cell.genreTitleLabel.textColor = UIColor.blackColor()
        } else {
            cell.genreTitleLabel.textColor = UIColor.whiteColor()
        }

        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.tableView.userInteractionEnabled = false
        
        let gameVC = self.storyboard.instantiateViewControllerWithIdentifier("Game") as GameViewController
        
        let genre = genres[indexPath.row]
        gameVC.genre = genre
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.networkController.discoverMovie(genre, callback: { (movies, errorDescription) -> Void in
                self.movies = movies
//                for movie in self.movies! {
//                    println(movie.id)
//                    println(movie.title)
//                }
                gameVC.movies = self.movies
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if self.navigationController {
                        self.navigationController.pushViewController(gameVC, animated: true)
                    }
                })
            })

        }
    }
    
    func segueToProfileController() {
        self.performSegueWithIdentifier("Profile", sender: self)
    }
    
    @IBAction func unwindToGenreVC(segue: UIStoryboardSegue!) {
        println("Pressing Play Again")
    }
    
    //MARK: GameKit Authentication
//    func authenticatePlayer() {
//        var localPlayer = GKLocalPlayer()
//        localPlayer.authenticateHandler = ({ (viewController: UIViewController!, error: NSError!) in
//            if viewController != nil {
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    self.presentViewController(viewController, animated: true, completion: nil)
//                })
//            } else {
//                if (localPlayer.authenticated == true) {
//                    self.gameCenterEnabled = true
//                    println("GameCenter Enabled")
//                    
//                    localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifier : String!, error : NSError!) -> Void in
//                        if (error) {
//                            println(error.localizedDescription)
//                        } else {
//                            println("Incoming ID \(leaderboardIdentifier)")
//                            self.leaderboardIdentifier = leaderboardIdentifier
//                            println("Identifier \(self.leaderboardIdentifier)")
//                        }
//                    })
//                }
//            else {
//                self.gameCenterEnabled = false
//                println("GameCenter Disabled")
//            }
//        }
//    })
//    }
    
//    func authenticatePlayer() {
//        var localPlayer = GKLocalPlayer()
//        localPlayer.authenticateHandler = {(viewController: UIViewController!, error: NSError!) -> Void in
//            
//            if viewController != nil {
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    self.presentViewController(viewController, animated: true, completion: nil)
//                })
//            }
//            else {
//                if localPlayer.authenticated == true {
//                    self.gameCenterEnabled = true
//                    localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifier: String!, error: NSError!) -> Void in
//                        if error != nil {
//                            println(error.localizedDescription)
//                        } else {
//                            println("Leaderboard ID = \(leaderboardIdentifier)")
//                            self.leaderboardIdentifier = leaderboardIdentifier
//                            println("Self.Leaderboard ID = \(self.leaderboardIdentifier)")
//                        }
//                    })
//                }
//                else {
//                    self.gameCenterEnabled = false
//                }
//            }
//        }
//        
//    }
}
