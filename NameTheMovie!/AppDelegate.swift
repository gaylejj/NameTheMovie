//
//  AppDelegate.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/11/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GameCenterManagerDelegate {
                            
    var window: UIWindow?
    
    let kPresentAuthenticationViewController = "present_authentication_view_controller"
    let kAuthenticationViewControllerFinished = "authentication_view_controller_finished"

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {

        // Setup Game Center
        GameCenterManager.sharedManager().delegate = self
        GameCenterManager.sharedManager().setupManager()
        
        Crashlytics.startWithAPIKey(API.crashlyticsKey())
                
        return true
    }
    
    //Required method
    func gameCenterManager(manager: GameCenterManager!, authenticateUser gameCenterLoginController: UIViewController!) {
        
        self.window?.rootViewController!.presentViewController(gameCenterLoginController, animated: true, completion: nil)

        NSNotificationCenter.defaultCenter().postNotificationName(self.kPresentAuthenticationViewController, object: nil)
    }
    
    func gameCenterManager(manager: GameCenterManager!, availabilityChanged availabilityInformation: [NSObject : AnyObject]!) {
        
        if manager.isGameCenterAvailable {
            NSNotificationCenter.defaultCenter().postNotificationName(self.kAuthenticationViewControllerFinished, object: nil, userInfo: availabilityInformation)            
        }
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

