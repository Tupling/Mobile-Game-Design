//
//  HelloWorldScene.h
//  TankGame
//
//  Created by Dale Tupling on 7/9/14.
//  Copyright Dale Tupling 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface HelloWorldScene : CCScene

// -----------------------------------------------------------------------

@property(nonatomic, strong) CCSprite *helicopter;
@property(nonatomic, strong) CCAction *flyAction;

+ (HelloWorldScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end