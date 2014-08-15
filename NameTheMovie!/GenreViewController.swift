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
    
    let networkController = NetworkController()
    
    var gameCenterEnabled = false
    let gamekitHelper = GameKitHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileButton = UIBarButtonItem(title: "Profile", style: UIBarButtonItemStyle.Plain, target: self, action: "segueToProfileController")
        self.navigationItem.rightBarButtonItem = profileButton

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("showGameCenterAuthController:"), name: "present_authentication_view_controller", object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func showGameCenterAuthController(note: NSNotification) {
        if let gkHelper = note.object as? GameKitHelper {
            self.presentViewController(gkHelper.authenticationViewController, animated: true, completion: { () -> Void in
                println("Showing auth vc")
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        gamekitHelper.authenticateLocalPlayer()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("GenreCell", forIndexPath: indexPath) as UITableViewCell
        
        let genre = self.genres[indexPath.row]
        
        cell.textLabel.text = genre.name
        cell.detailTextLabel.hidden = true

        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let gameVC = self.storyboard.instantiateViewControllerWithIdentifier("Game") as GameViewController
        
        let genre = genres[indexPath.row]
        
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
