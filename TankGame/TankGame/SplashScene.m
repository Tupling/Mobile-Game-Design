//
//  SplashScene.m
//  TankGame
//
//  Created by Dale Tupling on 7/31/14.
//  Copyright 2014 Dale Tupling. All rights reserved.
//

#import "SplashScene.h"
#import "IntroScene.h"


@implementation SplashScene
{
    CCButton *continueButton;
    
}


+ (SplashScene *)scene
{
    return [[self alloc] init];
}


-(id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tank Game" fontName:@"Chalkduster" fontSize:44.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.75f); // Middle of screen
    [self addChild:label];
    
    // Hello world
    CCLabelTTF *creator = [CCLabelTTF labelWithString:@"By: Dale Tupling" fontName:@"Verdana" fontSize:30.0f];
    creator.positionType = CCPositionTypeNormalized;
    creator.color = [CCColor whiteColor];
    creator.position = ccp(0.5f, 0.50f); // Middle of screen
    [self addChild:creator];
    

    
    //Back/Exit button to bring user back to the main menu or main launch screen of the game
    continueButton = [CCButton buttonWithTitle:@"Continue" fontName:@"Verdana" fontSize:20.0f];
    continueButton.positionType = CCPositionTypeNormalized;
    continueButton.position = ccp(0.85f, 0.15f); // Top Right of screen
    [continueButton setTarget:self selector:@selector(onContinue:)];
    [self addChild:continueButton];
    
    return self;
}


- (void)onContinue:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

@end
