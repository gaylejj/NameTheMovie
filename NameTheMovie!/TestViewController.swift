//
//  TestViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/11/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    let networkController = NetworkController()
    var genres : [Genre] = Genre.genreFromPlist()
    
    var westernMovies : [Movie]?
    var thrillerMovies : [Movie]?
    var dramaMovies : [Movie]?
    var fantasyMovies : [Movie]?
    var romanceMovies : [Movie]?
    var sfMovies : [Movie]?
    var adventureMovies : [Movie]?
    var animationMovies : [Movie]?
    var comedyMovies : [Movie]?
    var crimeMovies : [Movie]?
    var actionMovies : [Movie]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var indexPath = NSIndexPath()
        
//        for genre in genres {
//            let selectedGenre = genres[indexPath.row]
//            switch selectedGenre.id {
//            case 37:
//                networkController.discoverMovie(selectedGenre, callback: { (movies, errorDescription) -> Void in
//                    self.westernMovies = movies
//                })
//            default:
//                println("Test")
//            }
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
