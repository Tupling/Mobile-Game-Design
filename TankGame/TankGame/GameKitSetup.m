//
//  GameKitSetup.m
//  TankGame
//
//  Created by Dale Tupling on 8/22/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "GameKitSetup.h"

NSString *const PresentAuthViewController = @"present_auth_view";



@implementation GameKitSetup

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


//Game Kit Signelton
+(instancetype)sharedGameKit{
    
    static GameKitSetup *sharedGameKit;
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
            
            self.gameKitEnabeled = NO;
            NSLog(@"GAME CENTER NOT ENABLED");
            
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {

            //Enabled Game Center if user has been authenticated
            self.gameKitEnabeled = YES;
            
    
        } else {
            //User did not login and is not authenticated do not enable Game Center
            self.gameKitEnabeled = NO;
            
            NSLog(@"GAME CENTER NOT ENABLED");
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

@end
