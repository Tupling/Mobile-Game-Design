//
//  GameKitSetup.m
//  TankGame
//
//  Created by Dale Tupling on 8/22/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "GameKitSetup.h"

NSString *const PresentAuthViewController = @"present_auth_view";
static GameKitSetup *sharedGameKit = nil;



@implementation GameKitSetup

- (id)init
{
    self = [super init];
    if (self) {
        self.gameKitEnabeled = YES;
        
    
    }
    return self;
}


//Game Kit Signelton
+(GameKitSetup*)sharedGameKit{
    

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedGameKit = [[GameKitSetup alloc] init];
    });
    
    return sharedGameKit;
}

- (void)authCurrentPlayer
{
    //Get current Game Center logged in user
    GKLocalPlayer *currentPlayer = [GKLocalPlayer localPlayer];
    
    //Send current player to authenticateHandler
    currentPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        
        [self setAuthError:error];
        
        if(viewController != nil) {
            
            [self authenticateUserView:viewController];
            
        }else{
            
            if ([GKLocalPlayer localPlayer].authenticated) {
   
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                        self.gameKitEnabeled = NO;
                    }
                    
                    else{
                        self.gameKitEnabeled = YES;
                        self.leaderBoardID = leaderboardIdentifier;
                    }
                    
                   
                }];
                
                [self loadAchievements];
            }
            
            else{
                self.gameKitEnabeled = NO;
            }
        }
    };
}



- (void)authenticateUserView:(UIViewController *)authViewController
{
    if (authViewController != nil) {
        
        
        //Set user view controlelr to authView
        _userAuthenticateVC = authViewController;
        
        //Present AuthViewController notification
        [[NSNotificationCenter defaultCenter] postNotificationName:PresentAuthViewController object:self];
    }
}

- (void)setAuthError:(NSError *)error
{
    _authError = [error copy];
    
    if (_authError) {
        
        //Log GameKit error
        NSLog(@"GameKit Setup ERROR: %@", [[_authError userInfo] description]);
    }
    
}

//Load Achievements method (Called upon succcesful authentication of user)
-(void)loadAchievements
{
    self.achievementsDictionary = [[NSMutableDictionary alloc] init];
    
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        if (error != nil) {
            NSLog(@"Achievements Error: %@", [error localizedDescription]);
        }
        else if(achievements != nil) {
            
            for (GKAchievement *achievement in achievements) {
                
                self.achievementsDictionary[achievement.identifier] = achievement;
                
            }
            
        }
    }];
}

//Get Achievement Idenditier from Achievements
- (GKAchievement*)getAchievementForIdentifier:(NSString*)identifier
{
    GKAchievement *thisAchievement = [self.achievementsDictionary objectForKey:identifier];
    if (thisAchievement == nil)
    {
        thisAchievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        [self.achievementsDictionary setObject:thisAchievement forKey:thisAchievement.identifier];
    }
    return thisAchievement;
}


//Report Achievement Identifier

-(void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent
{
    GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
    if (achievement && achievement.percentComplete != 100.0) {
        achievement.percentComplete = percent;
        achievement.showsCompletionBanner = YES;
        
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Error while reporting achievement: %@", error.description);
            }
        }];
    }
}

//Reset all Achievements
//Clear local dictionary
//Clear game center data
-(void)resetAchievements
{
    
    self.achievementsDictionary = [[NSMutableDictionary alloc] init];
   
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil) {
             
             NSLog(@"Error Clearing Game Center Data: %@", [error localizedDescription]);
             
         }
         
             
    }];
}



@end
