//
//  GameOverScene.h
//  TankGame
//
//  Created by Dale Tupling on 7/24/14.
//  Copyright 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverScene : CCNodeColor
    
    +(CCScene *) winningScene:(BOOL)won;
    -(id)initWithWin:(BOOL)won;
    
@end
