//
//  GameKitSetup.h
//  TankGame
//
//  Created by Dale Tupling on 8/22/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameKitSetup : NSObject

extern NSString *const PresentAuthViewController;

@property (nonatomic, readonly)UIViewController *userAuthenticateVC;
@property (nonatomic, readonly)NSError *authError;
@property (nonatomic) BOOL gameKitEnabeled;

+(instancetype) sharedGameKit;

- (void)authCurrentPlayer;

@end
