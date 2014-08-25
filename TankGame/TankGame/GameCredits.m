//
//  GameCredits.m
//  TankGame
//
//  Created by Dale Tupling on 7/31/14.
//  Copyright 2014 Dale Tupling. All rights reserved.
//

#import "GameCredits.h"
#import "IntroScene.h"


@implementation GameCredits
{
    CCButton *backButton;
}


+ (GameCredits *)scene
{
    return [[self alloc] init];
}

-(id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    
    //CGSize viewSize = [[CCDirector sharedDirector] viewSize];
    
    //Back/Exit button to bring user back to the main menu or main launch screen of the game
    backButton = [CCButton buttonWithTitle:@"Back" fontName:@"Verdana-Bold" fontSize:16.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    
    //Game Title
    CCLabelTTF *gameTitle = [CCLabelTTF labelWithString:@"Tank Game" fontName:@"Chalkduster" fontSize:22.0f];
    gameTitle.positionType = CCPositionTypeNormalized;
    gameTitle.position = ccp(0.5f, 0.95f);
    gameTitle.color = [CCColor whiteColor];
    [self addChild:gameTitle];
    
    CCLabelTTF *creatorName = [CCLabelTTF labelWithString:@"Creator/Developer: \nDale Tupling" fontName:@"Verdana" fontSize:18.0f];
    creatorName.positionType = CCPositionTypeNormalized;
    creatorName.position = ccp(0.5f, 0.75f);
    creatorName.color = [CCColor whiteColor];
    [self addChild:creatorName];
    
    CCLabelTTF *spriteCredit = [CCLabelTTF labelWithString:@"Helicopter, Missile and Tank Sprites: \nmishonis (from Open Game Art)" fontName:@"Verdana" fontSize:18.0f];
    spriteCredit.positionType = CCPositionTypeNormalized;
    spriteCredit.position = ccp(0.5f, 0.55f);
    spriteCredit.color = [CCColor whiteColor];
    [self addChild:spriteCredit];
    
    CCLabelTTF *missileHeliExp = [CCLabelTTF labelWithString:@"Missile/Helicopter Collision Sound:\n dklon (from Open Game Art)" fontName:@"Verdana" fontSize:18.0f];
    missileHeliExp.positionType = CCPositionTypeNormalized;
    missileHeliExp.position = ccp(0.5f, 0.35f);
    missileHeliExp.color = [CCColor whiteColor];
    [self addChild:missileHeliExp];
    
    CCLabelTTF *missileLaunch = [CCLabelTTF labelWithString:@"Missile Launch Sound: \nhttp://www.freesoundeffects.com/" fontName:@"Verdana" fontSize:18.0f];
    missileLaunch.positionType = CCPositionTypeNormalized;
    missileLaunch.position = ccp(0.5f, 0.15f);
    missileLaunch.color = [CCColor whiteColor];
    [self addChild:missileLaunch];
    
    

	return self;
}


- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}


@end
