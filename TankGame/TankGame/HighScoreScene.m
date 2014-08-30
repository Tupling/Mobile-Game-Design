//
//  HighScoreScene.m
//  TankGame
//
//  Created by Dale Tupling on 8/25/14.
//  Copyright 2014 Dale Tupling. All rights reserved.
//

#import "HighScoreScene.h"
#import "IntroScene.h"
#import "AppDelegate.h"


@implementation HighScoreScene
{
    CCLabelTTF *scoreLabel_one;
    CCLabelTTF *scoreLabel_two;
    CCLabelTTF *scoreLabel_three;
    
    int firstScore;
    int secondScore;
    int thirdScore;
    
}

+ (HighScoreScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@" Top 3 Scores " fontName:@"Verdana" fontSize:40.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.80f); // Middle of screen
    [self addChild:label];
    
    // Helloworld scene button
    CCButton *quitButton = [CCButton buttonWithTitle:@" Exit " fontName:@"Verdana-Bold" fontSize:30.0f];
    quitButton.positionType = CCPositionTypeNormalized;
    quitButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [quitButton setTarget:self selector:@selector(onExitClicked:)];
    [self addChild:quitButton];
    
    //First Score Label
    scoreLabel_one = [CCLabelTTF labelWithString:@"" fontName:@"Verdana" fontSize:25.0f];
    scoreLabel_one.positionType = CCPositionTypeNormalized;
    scoreLabel_one.color = [CCColor whiteColor];
    scoreLabel_one.position = ccp(0.5f, 0.65f); // Middle of screen
    [self addChild:scoreLabel_one];
    
    //First Score Label
    scoreLabel_two = [CCLabelTTF labelWithString:@"" fontName:@"Verdana" fontSize:25.0f];
    scoreLabel_two.positionType = CCPositionTypeNormalized;
    scoreLabel_two.color = [CCColor whiteColor];
    scoreLabel_two.position = ccp(0.5f, 0.50f); // Middle of screen
    [self addChild:scoreLabel_two];
    
    //First Score Label
    scoreLabel_three = [CCLabelTTF labelWithString:@"" fontName:@"Verdana" fontSize:25.0f];
    scoreLabel_three.positionType = CCPositionTypeNormalized;
    scoreLabel_three.color = [CCColor whiteColor];
    scoreLabel_three.position = ccp(0.5f, 0.35f); // Middle of screen
    [self addChild:scoreLabel_three];
    
    // done
    
    [self loadScores];
	return self;
}

-(void)loadScores{
    NSManagedObjectContext *context = [ApplicationDelegate managedObjectContext];
    
    //Create new Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Request Entity EventInfo
    NSEntityDescription *eventEntity = [NSEntityDescription entityForName:@"Scores" inManagedObjectContext:context];
    
    //Set fetchRequest entity to EventInfo Description
    [fetchRequest setEntity:eventEntity];
    
    NSError * error;
    //Set events array to data in core data
    self.highScores = (NSMutableArray*)[context executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"%lu", (unsigned long)self.highScores.count);
    
    
    if([self.highScores count] != 0){
        if ([self.highScores count] > 0) {
            
            int lastObjectInt = (int*)[self.highScores indexOfObject:[self.highScores lastObject]];
            
            
            firstScore = lastObjectInt;
            
            
            [scoreLabel_one setString:[NSString stringWithFormat:@"%@  :  %@", [self.highScores[firstScore] valueForKey:@"userID"], [self.highScores[firstScore] valueForKey:@"score"]]];
        }
        
        if([self.highScores count] >= 2){
            
            
            secondScore = firstScore - 1;
            
            [scoreLabel_two setString:[NSString stringWithFormat:@"%@  :  %@", [self.highScores[secondScore] valueForKey:@"userID"], [self.highScores[secondScore] valueForKey:@"score"]]];
        }
        if ([self.highScores count] >= 3) {
            
            thirdScore = secondScore - 1;
            
            [scoreLabel_three setString:[NSString stringWithFormat:@"%@  :  %@", [self.highScores[thirdScore] valueForKey:@"userID"], [self.highScores[thirdScore] valueForKey:@"score"]]];
            
        }
    }else{
        NSLog(@"NO SAVED VALUES IN CORED DATA");
    }
    
    
    
}




// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------


- (void)onExitClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
@end


