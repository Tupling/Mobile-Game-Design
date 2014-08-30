//
//  HelloWorldScene.m
//  TankGame
//
//  Created by Dale Tupling on 7/9/14.
//  Copyright Dale Tupling 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "GameOverScene.h"
#import "CCAnimation.h"
#import "GameKitSetup.h"
#import "HighScores.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    
    
    //Local Vairables
    CCSprite *_tank;
    
    NSMutableArray *_missiles;
    NSMutableArray *_helicopters;
    CGSize viewableArea;
    
    CCButton *pauseButton;
    CCButton *backButton;
    CCButton *resumeButton;
    CCLabelTTF *scoreLabel;
    CCLabelTTF *missedHelis;
    CCLabelTTF *totalHitsLabel;
    
    CCActionMoveTo *launchMissle;
    
    GameKitSetup *gameKitInstance;
    
    BOOL playerAuth;
    
    int hits;
    int misses;
    int actualSpeed;
    int scoreTotal;
    int bonusScore;
    int constHits;
    
    
    
}
static HelloWorldScene *instance = nil;


// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}


// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    playerAuth = [GKLocalPlayer localPlayer].authenticated;
    
    gameKitInstance = [[GameKitSetup alloc] init];
    
    //Initiate hits counter to 0
    hits = 0;
    
    //Set consecutive hits for resetting immersive element
    constHits = 0;
    
    //3 missed helicopters equals game over
    misses = 0;
    
    //Instantiate helicaopter and missile arrays
    _helicopters = [[NSMutableArray alloc] init];
    _missiles = [[NSMutableArray alloc] init];
    
    
    //run heliSpawn method to helicopter every 2 seconds.
    //This will increase on level difficulty
    [self schedule:@selector(heliSpawn:) interval:2.0];
    
    //Create window size based on the total view size.
    viewableArea = [CCDirector sharedDirector].viewSize;
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //Add the Tank Sprite to the view
    _tank = [CCSprite spriteWithImageNamed:@"CompleteTank.png"];
    _tank.position  = ccp(20, 15);
    [self addChild:_tank];
    
    
    //Back/Exit button to bring user back to the main menu or main launch screen of the game
    backButton = [CCButton buttonWithTitle:@"Quit" fontName:@"Verdana-Bold" fontSize:16.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    
    //Pause button
    pauseButton = [CCButton buttonWithTitle:@"Pause" fontName:@"Verdana-Bold" fontSize:16.0f];
    pauseButton.positionType = CCPositionTypeNormalized;
    pauseButton.position = ccp(0.70f, 0.95f); // Top Right of screen
    [pauseButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:pauseButton];
    
    //Add score Label to view
    scoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Verdana-Bold" fontSize:16.0f];
    scoreLabel.positionType = CCPositionTypeNormalized;
    scoreLabel.position = ccp(0.10f, 0.95f);
    
    [self addChild:scoreLabel];
    
    //Add score Label to view
    totalHitsLabel = [CCLabelTTF labelWithString:@"Hits: 0" fontName:@"Verdana-Bold" fontSize:16.0f];
    totalHitsLabel.positionType = CCPositionTypeNormalized;
    totalHitsLabel.position = ccp(0.10f, 0.85f);
    
    [self addChild:totalHitsLabel];
    
    
    //Missed Helis Label
    //Add score Label to view
    missedHelis = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Misses: %d", misses] fontName:@"Verdana-Bold" fontSize:16.0f];
    missedHelis.positionType = CCPositionTypeNormalized;
    missedHelis.position = ccp(0.90f, 0.05f);
    
    [self addChild:missedHelis];
    
    // done
	return self;
}

//--------------------------------
//Helispawn method called during init
-(void)heliSpawn:(CCTime)time{
    
    //add helic to viewable area method
    [self addHelis];
}



//add helis method called from helispawn which is called during init

-(void)addHelis {
    
    //Set up SpriteSheet Animation
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"helicopters.plist"];
    
    //Setup Batch Node
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"helicopters.png"];
    [self addChild:spriteSheet];
    //Setup array of frames (Animations)
    NSMutableArray *flyAnimation = [NSMutableArray array];
    for (int i = 1; i <= 4; i++){
        [flyAnimation addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"chopper%d.png", i]]];
    }
    //Create Animation
    CCAnimation *fly = [CCAnimation
                        animationWithSpriteFrames:flyAnimation delay:0.1f];
    
    //Set sprite frame
    CCSpriteFrame *chopper = [CCSpriteFrame frameWithImageNamed:@"chopper1.png"];
    //set sprite image
    self.helicopter = [CCSprite spriteWithSpriteFrame:chopper];
    
    
    //set heli spawn location
    //gernates random height location to spawn helicopter on the right side of the viewable area
    viewableArea = [[CCDirector sharedDirector] viewSize];
    int locMinY = self.helicopter.contentSize.height/2;
    int locMaxY = viewableArea.height - self.helicopter.contentSize.height/2;
    int rangeY = locMaxY - locMinY;
    int actualLoc = (arc4random() % rangeY) + locMinY;
    
    self.helicopter.position = ccp(viewableArea.width + self.helicopter.contentSize.width/2, actualLoc);
    
    self.flyAction = [CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:fly]];
    [self.helicopter runAction:self.flyAction];
    
    
    //Add helicopter to spritesheet
    [spriteSheet addChild:self.helicopter];
    
    
    [_helicopters addObject:self.helicopter];
    
    
    //Detect how far a player is in the level. Increase speed based on hits.
    
    if (hits < 1)  {
        
        NSLog(@"Hitting < 3 hits");
        
        //set minimum and maximum speeds of helicopter
        int minSpeed = 6.0;
        int maxSpeed = 7.0;
        int rangeDuration = maxSpeed - minSpeed;
        actualSpeed = (arc4random() % rangeDuration) + minSpeed;
        
        
        
    } else if (hits > 1 && hits < 4 ){
        
        NSLog(@"Hitting > 3 hits but less then 6");
        //set minimum and maximum speeds of helicopter
        int minSpeed = 5.0;
        int maxSpeed = 8.0;
        int rangeDuration = maxSpeed - minSpeed;
        actualSpeed = (arc4random() % rangeDuration) + minSpeed;
        
        [[GameKitSetup sharedGameKit] reportAchievementIdentifier:@"first_chopper" percentComplete:100.0];
        
    }else if (hits > 4 && hits < 7){
        
        NSLog(@"Hitting > 6 hits");
        //set minimum and maximum speeds of helicopter
        int minSpeed = 2.0;
        int maxSpeed = 5.0;
        int rangeDuration = maxSpeed - minSpeed;
        actualSpeed = (arc4random() % rangeDuration) + minSpeed;
        
        [[GameKitSetup sharedGameKit] reportAchievementIdentifier:@"first_wave" percentComplete:100.0];
    }
    else if (hits > 7 ){
        
        NSLog(@"Hitting > 7 hits");
        //set minimum and maximum speeds of helicopter
        int minSpeed = 2.0;
        int maxSpeed = 3.0;
        int rangeDuration = maxSpeed - minSpeed;
        actualSpeed = (arc4random() % rangeDuration) + minSpeed;
        
        [[GameKitSetup sharedGameKit] reportAchievementIdentifier:@"second_wave" percentComplete:100.0];
    }
    
    if (hits == 30) {
        
        float completetion = hits * 100/ 50;
        
        [[GameKitSetup sharedGameKit] reportAchievementIdentifier:@"destroy_fifty" percentComplete:completetion];
    }
    
    
    CCActionMoveTo *moveHeli = [CCActionMoveTo actionWithDuration:actualSpeed position:ccp(-self.helicopter.contentSize.width/2, actualLoc)];
    
    //Run action of moving helicopter and Call block to remove helicsopter from parent when not in view.
    
    [self.helicopter runAction:[CCActionSequence actions:moveHeli, [CCActionCallBlock actionWithBlock:^{
        
        
        misses++;
        constHits = 0;
        
        [missedHelis setString:[NSString stringWithFormat:@"Misses: %d", misses]];
        
        //Remove helicopter from parent.
        
        CCNode *node = spriteSheet;
        [node removeFromParentAndCleanup:YES];
        if (misses == 1) {
            
            if(playerAuth){
                
                [[GameKitSetup sharedGameKit] reportAchievementIdentifier:@"passed_chopper" percentComplete:100.0];
            }
        }
        
        //Set losing condition
        if (misses == 3) {
            
            //Run method to submit score to leaderboard
            if (playerAuth) {
                
                [self sendAchieveDataToGameCenter];
            }
            
            
            
            //Change scene to gameOver scene
            CCScene *gameOver = [GameOverScene finalScore:scoreTotal];
            [[CCDirector sharedDirector] replaceScene:gameOver];
            
            
        }
        
    }], nil]];
    
    
}





//Game Center Score Update Method
-(void)sendFinalScore {
    
    GKScore *leaderBoardScore = [[GKScore alloc] initWithLeaderboardIdentifier:@"com.daletupling.TankGame.Tester"];
    leaderBoardScore.value = scoreTotal;
    
    [GKScore reportScores:@[leaderBoardScore] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
        }
    }];
    
}

-(void)addHighScore{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //Create new Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Request Entity EventInfo
    NSEntityDescription *eventEntity = [NSEntityDescription entityForName:@"EventInfo" inManagedObjectContext:context];
    
    //Set fetchRequest entity to EventInfo Description
    [fetchRequest setEntity:eventEntity];
    
    NSError * error;
    //Set events array to data in core data
    self.highScores = [context executeFetchRequest:fetchRequest error:&error];
    
    if (self.highScores != nil) {
        
    }
    
}

-(void)sendAchieveDataToGameCenter {
    
    //Completion Percentage
    float completetion = 0.0;
    
    
    if(scoreTotal >= 100){
        
        completetion = scoreTotal * 100 / 100;
        
        [[GameKitSetup sharedGameKit] reportAchievementIdentifier:@"one_hundred" percentComplete:completetion];
        
    }
    if (scoreTotal >= 200) {
        
        completetion = scoreTotal * 100 / 200;
        
        [[GameKitSetup sharedGameKit] reportAchievementIdentifier:@"two_hundred" percentComplete:completetion];
        
    }
    if (scoreTotal >= 300) {
        
        completetion = scoreTotal * 100 / 300;
        
        [[GameKitSetup sharedGameKit] reportAchievementIdentifier:@"three_hunred" percentComplete:completetion];
        
    }
    
    
    
    
    
}




// -----------------------------------------------------------------------

- (void)dealloc
{
    
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //Get screne touches and locations
    //UITouch *touch = [touch anyObject];
    CGPoint touchLoc = [touch locationInNode:self];
    
    //Set screneSize to window or view size
    viewableArea = [[CCDirector sharedDirector] viewSize];
    //Set _missle sprite to shell image
    CCSprite *_missile = [CCSprite spriteWithImageNamed:@"shell.png"];
    CCSprite *_secondMissile = [CCSprite spriteWithImageNamed:@"shell.png"];
    CCSprite *_thirdMissile = [CCSprite spriteWithImageNamed:@"shell.png"];
    
    //setup the location of initial missile launch
    _missile.position = ccp(20, 15);
    
    //Get the offset of missile to the Touch Location
    CGPoint offset = ccpSub(touchLoc, _missile.position);
    
    //Verify touchpoint is valid location on viewable area
    if (offset.x <= 0) return;
    
    //Make sure touch point is not the reload tank point (touching the tank) before launching missle
    
    
    if(!CGRectContainsPoint(_tank.boundingBox, touchLoc)){
        //Add the missile to the view
        [self addChild:_missile];
        
        [_missiles addObject:_missile];
        
    }
    
    //Get the launch point of the missile and the touch from user interaction
    //launch missile to touch point
    
    int actualXLoc = viewableArea.width + (_missile.contentSize.width/2);
    float ratio = (float) offset.y / (float) offset.x;
    int actualYLoc = (actualXLoc * ratio) + _missile.position.y;
    CGPoint destination = ccp(actualXLoc, actualYLoc);
    
    //Get the x and y offset location from the touch point and the origination location of missile.
    int offsetActualXLoc = actualXLoc - _missile.position.x;
    int offsetActualYLoc = actualYLoc - _missile.position.y;
    
    float length = sqrtf((offsetActualXLoc * offsetActualXLoc) + (offsetActualYLoc * offsetActualYLoc));
    float veloc = 480/1;
    float duration = length/veloc;
    
    
    
    //Launch missle to desination of touch point by user.
    launchMissle = [CCActionMoveTo actionWithDuration:duration position:destination];
    
    
    //Run action of launching missile and Call block to remove missile from parent when not in view.
    [_missile runAction:[CCActionSequence actions:launchMissle, [CCActionCallBlock actionWithBlock:^{
        
        
        //Remove missile from parent
        
        CCNode *node = _missile;
        if (_missile.position.x > viewableArea.width) {
            [node removeFromParentAndCleanup:YES];
            NSLog(@"MISSILE REMOVED");
        }
        
        
    }], nil]];
    
    
    
    //Launch second missile
    
    if (constHits == 5) {
        
        if  (playerAuth){
            
            
            [[GameKitSetup sharedGameKit] reportAchievementIdentifier:@"two_rounds" percentComplete:100.0];
            
            
            
        }
        
        
        if(!CGRectContainsPoint(_tank.boundingBox, touchLoc)){
            //Add the missile to the view
            [self addChild:_secondMissile];
            
            [_missiles addObject:_secondMissile];
            
        }
        
        //Get the launch point of the missile and the touch from user interaction
        //launch missile to touch point
        
        int actualXLoc = viewableArea.width + (_secondMissile.contentSize.width/2);
        float ratio = (float) offset.y / (float) offset.x;
        int actualYLoc = (actualXLoc * ratio) + _secondMissile.position.y;
        CGPoint destination = ccp(actualXLoc, actualYLoc);
        
        //Get the x and y offset location from the touch point and the origination location of missile.
        int offsetActualXLoc = actualXLoc - _secondMissile.position.x;
        int offsetActualYLoc = actualYLoc - _secondMissile.position.y;
        
        float length = sqrtf((offsetActualXLoc * offsetActualXLoc) + (offsetActualYLoc * offsetActualYLoc));
        float veloc = 510/1;
        float duration = length/veloc;
        
        
        
        //Launch missle to desination of touch point by user.
        launchMissle = [CCActionMoveTo actionWithDuration:duration position:destination];
        
        
        //Run action of launching missile and Call block to remove missile from parent when not in view.
        [_secondMissile runAction:[CCActionSequence actions:launchMissle, [CCActionCallBlock actionWithBlock:^{
            
            
            //Remove missile from parent
            
            CCNode *node = _secondMissile;
            if (_secondMissile.position.x > viewableArea.width) {
                [node removeFromParentAndCleanup:YES];
                NSLog(@"MISSILE REMOVED");
            }
            
            
        }], nil]];
        
        
    }
    
    if (constHits >= 8) {
        
        
        if(!CGRectContainsPoint(_tank.boundingBox, touchLoc)){
            //Add the missile to the view
            [self addChild:_thirdMissile];
            
            [_missiles addObject:_thirdMissile];
            
        }
        
        //Get the launch point of the missile and the touch from user interaction
        //launch missile to touch point
        
        int actualXLoc = viewableArea.width + (_thirdMissile.contentSize.width/2);
        float ratio = (float) offset.y / (float) offset.x;
        int actualYLoc = (actualXLoc * ratio) + _thirdMissile.position.y;
        CGPoint destination = ccp(actualXLoc, actualYLoc);
        
        //Get the x and y offset location from the touch point and the origination location of missile.
        int offsetActualXLoc = actualXLoc - _thirdMissile.position.x;
        int offsetActualYLoc = actualYLoc - _thirdMissile.position.y;
        
        float length = sqrtf((offsetActualXLoc * offsetActualXLoc) + (offsetActualYLoc * offsetActualYLoc));
        float veloc = 450/1;
        float duration = length/veloc;
        
        
        
        //Launch missle to desination of touch point by user.
        launchMissle = [CCActionMoveTo actionWithDuration:duration position:destination];
        
        
        //Run action of launching missile and Call block to remove missile from parent when not in view.
        [_thirdMissile runAction:[CCActionSequence actions:launchMissle, [CCActionCallBlock actionWithBlock:^{
            
            
            //Remove missile from parent
            
            CCNode *node = _thirdMissile;
            if (_thirdMissile.position.x > viewableArea.width) {
                [node removeFromParentAndCleanup:YES];
                NSLog(@"MISSILE REMOVED");
            }
            
            
        }], nil]];
        
    }
    
    
    //[self removeChild:_missile];
    [[OALSimpleAudio sharedInstance] playBg:@"aexp2.wav" loop:NO];
    
    
    if(CGRectContainsPoint(_tank.textureRect, touchLoc)){
        
        [[OALSimpleAudio sharedInstance] playBg:@"tank_reload.mp3" loop:NO];
    }
    
}


//Collision detection update screen by removing sprites when collision occurs
-(void)update:(CCTime)delta{
    //Instantiatr delete missles array
    NSMutableArray *deleteMissles = [[NSMutableArray alloc] init];
    //loop through missile array and instantiate deleted helicopter array
    for (CCSprite *missile in _missiles){
        
        NSMutableArray *deleteHelis = [[NSMutableArray alloc] init];
        
        //loop through helicopters and detect collision based on bounding box of missile and helicopter,
        //add helicopters to delete array when collision detected
        for (CCSprite *helis in _helicopters) {
            
            if (CGRectIntersectsRect(missile.boundingBox, helis.boundingBox)) {
                [[OALSimpleAudio sharedInstance] playBg:@"boom6.wav" loop:NO];
                [deleteHelis addObject:helis];
                
                //Increase hits
                hits++;
                constHits++;
                
                
                //Multiply hits by 10 to get totalScore
                if (hits <= 5){
                    
                    scoreTotal = hits * 10;
                    
                }else if(hits > 5){
                    
                    bonusScore = 15;
                    scoreTotal = scoreTotal + bonusScore;
                }
                else if(hits > 10){
                    
                    bonusScore = 30;
                    scoreTotal = scoreTotal + bonusScore;
                }
                
                
                //Update ScoreLabel with string to include scoreTotal
                [scoreLabel setString:[NSString stringWithFormat:@"Score: %d", scoreTotal]];
                
                //Update Hitds Label
                [totalHitsLabel setString:[NSString stringWithFormat:@"Hits: %d", hits]];
                
                
                
                
                
                
                //Level one max score 300
                /* if (scoreTotal == 300) {
                 CCScene *gameOver = [GameOverScene winningScene:YES];
                 [[CCDirector sharedDirector] replaceScene:gameOver];
                 }
                 */
                
                
                
            }
        }
        //loop through delete helicopters array and remove the helicopter object one by one
        for(CCSprite *heli in deleteHelis){
            CCNode *node = heli;
            [_helicopters removeObject: heli];
            [node removeFromParentAndCleanup:YES];
            
            
        }
        //if every helicopter has been removed from delete helis array add missiles to delete missile array
        if (deleteHelis.count > 0) {
            
            [deleteMissles addObject:missile];
        }
    }
    //loop through delete missiles and remove each missile object
    for(CCSprite *missile in deleteMissles){
        CCNode *node = missile;
        [_missiles removeObject:missile];
        [node removeFromParentAndCleanup:YES];
    }
}


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

//Method for pausing game
- (void)onPauseClicked:(id)sender
{
    
    //Put game in animation on Pause
    [[CCDirector sharedDirector] pause];
    
    //Hide both quit and pause buttong
    [self removeChild:pauseButton];
    [self removeChild:backButton];
    
    //Resume button
    resumeButton = [CCButton buttonWithTitle:@"Resume" fontName:@"Verdana-Bold" fontSize:22.0f];
    resumeButton.positionType = CCPositionTypeNormalized;
    resumeButton.position = ccp(0.50f, 0.50f); // Top Right of screen
    [resumeButton setTarget:self selector:@selector(resumeGamePlay:)];
    [self addChild:resumeButton];
    
    
}


//Resume Gameplay
- (void)resumeGamePlay:(id)sender
{
    
    //Resume Game Animations
    [[CCDirector sharedDirector] resume];
    
    //Show buttons
    [self addChild:pauseButton];
    [self addChild:backButton];
    
    //Remove Resume Button
    [self removeChild:resumeButton];
    
    
}

// -----------------------------------------------------------------------
@end
