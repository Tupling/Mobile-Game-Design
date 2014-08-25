//
//  GameOverScene.h
//  TankGame
//
//  Created by Dale Tupling on 7/24/14.
//  Copyright 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverScene : CCNodeColor <UITextFieldDelegate>
    
+(CCScene *) finalScore:(int)score;
-(id)initWithFinalScore:(int)score;

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSArray *highScores;

@property(nonatomic) int gameScore;

    
@end
