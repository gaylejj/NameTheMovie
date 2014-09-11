//
//  OpeningViewController.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/15/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class OpeningViewController: UIViewController {

    @IBOutlet weak var tmdbLogoImageView: UIImageView!
    
    @IBOutlet weak var tmdbStatementLabel: UILabel!
    
    @IBOutlet weak var appTitleLabel: UILabel!
    
    @IBOutlet weak var createdByLabel: UILabel!
    
    @IBOutlet weak var clapboardImageView: UIImageView!
    
    var timer : NSTimer!
    
    var gameCenterEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tmdbStatementLabel.numberOfLines = 0
        self.tmdbStatementLabel.adjustsFontSizeToFitWidth = true
        self.appTitleLabel.adjustsFontSizeToFitWidth = true
        self.createdByLabel.adjustsFontSizeToFitWidth = true
        
        self.clapboardImageView.backgroundColor = UIColor.clearColor()
        
//        self.view.backgroundColor = UIColor(red: 255/255, green: 103/255, blue: 97/255, alpha: 1.0)
        
        if GameCenterManager.sharedManager().isGameCenterAvailable == true {
            
        }

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("segueToGenreVC"), name: appDelegate.kAuthenticationViewControllerFinished, object: nil)
    
    }
    
    func segueToGenreVC() {
        if let player = GameCenterManager.sharedManager().localPlayerData() {
            self.gameCenterEnabled = true
        }

        self.performSegueWithIdentifier("first", sender: self)
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
