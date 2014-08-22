//
//  IntroScene.m
//  TankGame
//
//  Created by Dale Tupling on 7/9/14.
//  Copyright Dale Tupling 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "GameCredits.h"
#import "GameTutorial.h"
#import "GameKitSetup.h"



// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthViewController) name:PresentAuthViewController object:nil];
    
    [[GameKitSetup sharedGameKit] authCurrentPlayer];
    
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Verdana" fontSize:40.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.80f); // Middle of screen
    [self addChild:label];
    
    // Helloworld scene button
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@" Play " fontName:@"Verdana-Bold" fontSize:30.0f];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.55f);
    [helloWorldButton setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:helloWorldButton];
    
    //Credits Button
    CCButton *gameCreditsButton = [CCButton buttonWithTitle:@" Credits " fontName:@"Verdana-Bold" fontSize:18.0f];
    gameCreditsButton.positionType = CCPositionTypeNormalized;
    gameCreditsButton.position = ccp(0.5f, 0.35f);
    [gameCreditsButton setTarget:self selector:@selector(onCreditsClicked:)];
    [self addChild:gameCreditsButton];
    
    //Tutorial
    //Credits Button
    CCButton *tutorialButton = [CCButton buttonWithTitle:@" Tutorial " fontName:@"Verdana-Bold" fontSize:18.0f];
    tutorialButton.positionType = CCPositionTypeNormalized;
    tutorialButton.position = ccp(0.5f, 0.25f);
    [tutorialButton setTarget:self selector:@selector(onTutorialClicked:)];
    [self addChild:tutorialButton];

    // done
	return self;
}

- (void)showAuthViewController
{
    GameKitSetup *gameKit = [GameKitSetup sharedGameKit];
    
    if(gameKit.userAuthenticateVC != nil){
    [[CCDirector sharedDirector] presentViewController:gameKit.userAuthenticateVC animated:YES completion:nil];
    }

}



// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onPlayClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onCreditsClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[GameCredits scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onTutorialClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[GameTutorial scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
