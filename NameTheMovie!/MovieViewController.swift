//
//  MovieViewController.swift
//  Movie Game
//
//  Created by Jeff Gayle on 8/11/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UITextFieldDelegate {
    
    var selectedMovie : Movie?
    let networkController = NetworkController()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkController.fetchMovieForClick(selectedMovie, callback: { (movie, errorDescription) -> Void in
            self.selectedMovie = movie
            println(self.selectedMovie?.overview)
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.titleLabel.text = "Title: \(self.selectedMovie!.title), id: \(self.selectedMovie!.id)"
                if self.selectedMovie?.overview != nil {
                    self.overviewTextView.text = self.selectedMovie!.overview
                } else {
                    self.overviewTextView.text = "No overview found"
                }
            }
        })
        

//        
//        self.titleLabel.text = "Title: \(selectedMovie?.title), id: \(selectedMovie?.id)"
//        println(selectedMovie?.title)
//        if selectedMovie?.overview != nil {
//            self.overviewTextView.text = selectedMovie?.overview
//        } else {
//            self.overviewTextView.text = "No overview found"
//        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
