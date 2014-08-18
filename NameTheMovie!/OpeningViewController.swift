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
    
    let gamekitHelper = GameKitHelper()
    
    var timer : NSTimer!
    
    var gameCenterEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tmdbStatementLabel.numberOfLines = 0
        self.tmdbStatementLabel.adjustsFontSizeToFitWidth = true
        self.appTitleLabel.adjustsFontSizeToFitWidth = true
        self.createdByLabel.adjustsFontSizeToFitWidth = true
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "segueToGenreVC", userInfo: nil, repeats: false)
        
        self.view.backgroundColor = UIColor(red: 255/255, green: 103/255, blue: 97/255, alpha: 1.0)
        
        self.gamekitHelper.authenticateLocalPlayer()
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
    
    func segueToGenreVC() {
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
