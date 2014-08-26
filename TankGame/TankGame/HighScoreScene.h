//
//  HighScoreScene.h
//  TankGame
//
//  Created by Dale Tupling on 8/25/14.
//  Copyright 2014 Dale Tupling. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import <Foundation/Foundation.h>

@interface HighScoreScene : CCScene {
    
}

@property(nonatomic, strong) NSMutableArray *highScores;

+ (HighScoreScene *)scene;
- (id)init;


@end
