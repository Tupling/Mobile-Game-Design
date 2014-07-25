//
//  GameOverScene.m
//  TankGame
//
//  Created by Dale Tupling on 7/24/14.
//  Copyright 2014 Dale Tupling. All rights reserved.
//

#import "GameOverScene.h"
#import "HelloWorldScene.h"
#import "IntroScene.h"


@implementation GameOverScene
{
    CCButton *backButton;
}

+(CCScene *) winningScene:(BOOL)won {
    CCScene *scene =[CCScene node];
    GameOverScene *layer = [[GameOverScene alloc] initWithWin:won];
    [scene addChild:layer];
    
    return scene;
              
}


-(id)initWithWin:(BOOL)won {
    if(self = [super initWithColor:[CCColor grayColor]]){
    CGSize viewSize = [[CCDirector sharedDirector] viewSize];
  
    
    NSString *gameCondition;
    if(won) {
        gameCondition = @"You achieved a score of 100!";
    }else {
        gameCondition = @"You failed! Letting 3 Choppers Escape";
    }
    
    CCLabelTTF *gameStatus = [CCLabelTTF labelWithString:gameCondition fontName:@"Chalkduster" fontSize:18.0f];
    gameStatus.position = ccp(viewSize.width/2, viewSize.height/2);
    gameStatus.color = [CCColor whiteColor];
    [self addChild:gameStatus];
    
    
    //Back/Exit button to bring user back to the main menu or main launch screen of the game
    backButton = [CCButton buttonWithTitle:@"Quit" fontName:@"Verdana-Bold" fontSize:16.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.5f, 0.35f); // Top Right of screen
    backButton.color = [CCColor whiteColor];
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    }
    return self;
}

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

@end
