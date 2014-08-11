//
//  ViewController.swift
//  Movie Game
//
//  Created by Jeff Gayle on 8/11/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies : [Movie]?
    var genres = Genre.genreFromPlist()
    
    let networkController = NetworkController()
    
    let url = "http://image.tmdb.org/t/p/w185"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 10
        
        let searchButton = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.Plain, target: self, action: "listOfMovies")
        
        self.navigationItem.rightBarButtonItem = searchButton
        
        println(self.genres.count)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableView Data Source
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Movie", forIndexPath: indexPath) as UITableViewCell
        
        let movie = self.movies![indexPath.row] as Movie
        
        cell.textLabel.text = movie.title!
        
        if movie.poster_path != nil {
            let posterURL = NSURL(string: url + movie.poster_path!)
            let data = NSData(contentsOfURL: posterURL, options: nil, error: nil)
            
            cell.imageView.image = UIImage(data: data)
        } else {
            cell.detailTextLabel.text = "Poster not available"
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if self.movies != nil {
            return self.movies!.count
        } else {
            return 0
        }
    }
    
    //MARK: UITableView Delegate
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let movieVC = self.storyboard.instantiateViewControllerWithIdentifier("MovieVC") as MovieViewController
        
        let movie = self.movies![indexPath.row] as Movie
        
        movieVC.selectedMovie = movie
        
        if self.navigationController {
            self.navigationController.pushViewController(movieVC, animated: true)
        }
    }
    
    //MARK: Search Bar
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        let searchTerm = searchBar.text
        
        let finalSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        searchBar.resignFirstResponder()
        
        networkController.fetchMovie(finalSearchTerm, {(movies: [Movie]?, errorDescription: String?) -> Void in
            
            self.movies = movies
            NSOperationQueue.mainQueue().addOperationWithBlock(
                {() -> Void in
                    self.tableView.reloadData()
                    
            })
        })
    }
    
    //Search Button Hardcode
    func listOfMovies() {
        //        networkController.fetchMovie("Matrix", callback: {(movies: [Movie]?, errorDescription: String?) -> Void in
        //
        //                self.movies = movies
        //                NSOperationQueue.mainQueue().addOperationWithBlock(
        //                    {() -> Void in
        //                        self.tableView.reloadData()
        //
        //                    })
        //            })
        
        let randomIndex = Int(arc4random_uniform(UInt32(genres.count)))
        let randomGenre = genres[randomIndex]
        
        println("List of Movies Call: \(randomGenre.id)")
        println("List of Movies Call: \(randomGenre.name)")
        
        
        networkController.discoverMovie(randomGenre, callback: { (movies, errorDescription) -> Void in
            
            self.movies = movies
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.tableView.reloadData()
            })
        })
    }
    
    //    func listOfGenres() {
    //        for genre in genres {
    //            println(genre.name)
    //            println(genre.id)
    //        }
    //    }
    
}

