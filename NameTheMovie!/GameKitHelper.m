//
//  GameKitHelper.m
//  CircuitRacer
//
//  Created by Main Account on 9/23/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "GameKitHelper.h"
#import "NameTheMovie_-Swift.h"

NSString *const PresentAuthenticationViewController =
  @"present_authentication_view_controller";
NSString *const AuthenticationViewControllerFinished =
@"authentication_view_controller_finished";

@interface GameKitHelper()<GKGameCenterControllerDelegate>
@end

@implementation GameKitHelper {
  BOOL _enableGameCenter;
}

+ (instancetype)sharedGameKitHelper
{
  static GameKitHelper *sharedGameKitHelper;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedGameKitHelper = [[GameKitHelper alloc] init];
  });
  return sharedGameKitHelper;
}

- (id)init
{
  self = [super init];
  if (self) {
    _enableGameCenter = YES;
  }
  return self;
}

- (void)authenticateLocalPlayer
{
  //1
  GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
  //2
  localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
      //3
     [self setLastError:error];
      
      if(viewController != nil) {
        //4
        [self setAuthenticationViewController:viewController];
      } else if([GKLocalPlayer localPlayer].isAuthenticated) {
        //5
        _enableGameCenter = YES;
          NSLog(@"GameCenter Enabled");
        [[GKLocalPlayer localPlayer]loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                NSLog(@"Leadeboard ID: %@", _leaderboardIdentifier);
                _leaderboardIdentifier = leaderboardIdentifier;
            }
        }];
      } else {
        //6
        _enableGameCenter = NO;
          NSLog(@"GameCenter Disabled");
      }
  };
}

- (void)setAuthenticationViewController:
  (UIViewController *)authenticationViewController
{
  if (authenticationViewController != nil) {
    _authenticationViewController = authenticationViewController;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:PresentAuthenticationViewController
     object:self];
  }
}

- (void)setLastError:(NSError *)error
{
  _lastError = [error copy];
  if (_lastError) {
    NSLog(@"GameKitHelper ERROR: %@",
          [[_lastError userInfo] description]);
  }
}

- (void)reportAchievements:(NSArray *)achievements
{
  if (!_enableGameCenter) {
    NSLog(@"Local play is not authenticated");
  }
  [GKAchievement reportAchievements:achievements
              withCompletionHandler:^(NSError *error ){
                [self setLastError:error];
              }];
}

- (void)showGKGameCenterViewController:
  (UIViewController *)viewController
{
  if (!_enableGameCenter) {
    NSLog(@"Local play is not authenticated");
  }
  //1
  GKGameCenterViewController *gameCenterViewController =
    [[GKGameCenterViewController alloc] init];
    
  //2
  gameCenterViewController.gameCenterDelegate = self;
    
  //3
  gameCenterViewController.viewState =
    GKGameCenterViewControllerStateAchievements;
    
  //4
  [viewController presentViewController:gameCenterViewController
                               animated:YES
                             completion:nil];
}

- (void)gameCenterViewControllerDidFinish:
  (GKGameCenterViewController *)gameCenterViewController
{
  [gameCenterViewController dismissViewControllerAnimated:YES completion:^{
      [[NSNotificationCenter defaultCenter] postNotificationName:AuthenticationViewControllerFinished object:nil userInfo:nil];      
  }];
}

//- (void)showLeaderboardAndAchievements:(BOOL)ShouldShowLeaderboard {
//    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc]init];
//    gcViewController.gameCenterDelegate = self;
//    
//    if (ShouldShowLeaderboard) {
//        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
//        gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
//    } else {
//        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
//    }
//    
//    [self presentViewController: gcViewController animated: YES completion: nil];
//}


@end
