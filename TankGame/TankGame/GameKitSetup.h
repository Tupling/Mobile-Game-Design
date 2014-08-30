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
@property (nonatomic, retain)NSString *leaderBoardID;

@property(nonatomic, retain) NSMutableDictionary *achievementsDictionary;

+(GameKitSetup*) sharedGameKit;

-(void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent;

-(void)resetAchievements;

-(void)authCurrentPlayer;

@end
