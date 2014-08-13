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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileButton = UIBarButtonItem(title: "Profile", style: UIBarButtonItemStyle.Plain, target: self, action: "segueToProfileController")
        self.navigationItem.rightBarButtonItem = profileButton
        
//        let genre = genres[1]
//        
//        networkController.discoverMovie(genre, callback: { (movies, errorDescription) -> Void in
//            self.movies = movies
//            for movie in self.movies! {
//                println(movie.id)
//                println(movie.title)
//            }
//        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("GenreCell", forIndexPath: indexPath) as UITableViewCell
        
//        if self.movies != nil {
//            let movie = self.movies![indexPath.row]
//            
//            cell.textLabel.text = movie.title!
//            cell.detailTextLabel.text = "\(movie.id!)"
//        } else {
//            cell.textLabel.text = "No movie found"
//            cell.detailTextLabel.text = "No ID Found"
//        }
        
        let genre = self.genres[indexPath.row]
        
        cell.textLabel.text = genre.name
        cell.detailTextLabel.text = genre.id

        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let gameVC = self.storyboard.instantiateViewControllerWithIdentifier("Game") as GameViewController
        
        let genre = genres[indexPath.row]
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.networkController.discoverMovie(genre, callback: { (movies, errorDescription) -> Void in
                self.movies = movies
                for movie in self.movies! {
                    println(movie.id)
                    println(movie.title)
                }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
