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
#import "GameKitSetup.h"


@implementation GameOverScene
{
    CCButton *backButton;
    int passedScore;
    UITextField *textField;
    GameKitSetup *gameKit;
}

+(CCScene *) finalScore:(int)score{
    CCScene *scene =[CCScene node];
    GameOverScene *layer = [[GameOverScene alloc] initWithFinalScore:score];
    [scene addChild:layer];
    
    return scene;
    
}


-(id)initWithFinalScore:(int)score {
    if(self = [super initWithColor:[CCColor grayColor]]){
        CGSize viewSize = [[CCDirector sharedDirector] viewSize];
        
        NSString *gameCondition;
        
        gameKit = [[GameKitSetup alloc] init];
        
        gameCondition = [NSString stringWithFormat:@"You achieved a score of %d", score];
        
        

        
        if (gameKit.authError || gameKit.gameKitEnabeled == NO) {
            CCLabelTTF *gameStatus = [CCLabelTTF labelWithString:gameCondition fontName:@"Chalkduster" fontSize:18.0f];
            gameStatus.positionType = CCPositionTypeNormalized;
            gameStatus.position = ccp(0.5f, 0.95f);
            gameStatus.color = [CCColor whiteColor];
            [self addChild:gameStatus];
            
            textField = [[UITextField alloc] initWithFrame:CGRectMake(viewSize.width* 0.3, viewSize.height* 0.1, 250, 50)];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.placeholder = @"Enter Initials";
            [[[CCDirector sharedDirector] view]addSubview:textField];
            
            //Back/Exit button to bring user back to the main menu or main launch screen of the game
            backButton = [CCButton buttonWithTitle:@"Enter Score" fontName:@"Verdana-Bold" fontSize:16.0f];
            backButton.positionType = CCPositionTypeNormalized;
            backButton.position = ccp(0.5f, 0.35f); // Top Right of screen
            backButton.color = [CCColor whiteColor];
            [backButton setTarget:self selector:@selector(onBackClicked:)];
            [self addChild:backButton];
            
        }else{
            
            CCLabelTTF *gameStatus = [CCLabelTTF labelWithString:gameCondition fontName:@"Chalkduster" fontSize:18.0f];
            gameStatus.positionType = CCPositionTypeNormalized;
            gameStatus.position = ccp(0.5f, 0.55f);
            gameStatus.color = [CCColor whiteColor];
            [self addChild:gameStatus];
            
            //Back/Exit button to bring user back to the main menu or main launch screen of the game
            backButton = [CCButton buttonWithTitle:@"Exit" fontName:@"Verdana-Bold" fontSize:16.0f];
            backButton.positionType = CCPositionTypeNormalized;
            backButton.position = ccp(0.5f, 0.35f); // Top Right of screen
            backButton.color = [CCColor whiteColor];
            [backButton setTarget:self selector:@selector(onBackClicked:)];
            [self addChild:backButton];
        }
        
        
        
        

    }
    return self;
}

- (void)onBackClicked:(id)sender
{
    if (gameKit.authError) {
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        //Create new Fetch Request
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        //Request Entity EventInfo
        NSEntityDescription *eventEntity = [NSEntityDescription entityForName:@"HighScores" inManagedObjectContext:context];
        
        //Set fetchRequest entity to EventInfo Description
        [fetchRequest setEntity:eventEntity];
        
        NSError * error;
        //Set events array to data in core data
        self.highScores = [context executeFetchRequest:fetchRequest error:&error];
        
        if (self.highScores != nil) {
            
            NSLog(@"CoreData Not Nil");
        }else{
            NSLog(@"CoreDate == NIL");
        }
        
    }else{
        
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
    }
    [textField removeFromSuperview];
    
    
}

@end
