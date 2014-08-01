//
//  GameTutorial.h
//  TankGame
//
//  Created by Dale Tupling on 7/31/14.
//  Copyright 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface GameTutorial : CCScene {
    
}


@property(nonatomic, strong) CCSprite *helicopter;
@property(nonatomic, strong) CCAction *flyAction;

+ (GameTutorial *)scene;
- (id)init;


@end
