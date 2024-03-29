//
//  GameTutorial.m
//  TankGame
//
//  Created by Dale Tupling on 7/31/14.
//  Copyright 2014 Dale Tupling. All rights reserved.
//

#import "GameTutorial.h"
#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "GameOverScene.h"
#import "CCAnimation.h"


@implementation GameTutorial
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
    
    CCSpriteBatchNode *spriteSheet;
    
    int hits;
    int misses;
    int missileCount;
    
    CCLabelTTF *tutorialLabel;
    CCButton *okayButton;
    
    BOOL sectionOneComplete;
    BOOL sectionTwoComplete;
    BOOL sectionThreeComplete;
    BOOL sectionFourComplete;
    
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (GameTutorial *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    
    sectionOneComplete = false;
    sectionTwoComplete = false;
    sectionThreeComplete = false;
    sectionFourComplete = false;
    
    missileCount = 3;
    
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    //Initiate hits counter to 0
    hits = 0;
    //3 missed helicopters equals game over
    misses = 3;
    
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
    backButton = [CCButton buttonWithTitle:@" Quit " fontName:@"Verdana-Bold" fontSize:16.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    
    //Pause button
    pauseButton = [CCButton buttonWithTitle:@" Pause " fontName:@"Verdana-Bold" fontSize:16.0f];
    pauseButton.positionType = CCPositionTypeNormalized;
    pauseButton.position = ccp(0.70f, 0.95f); // Top Right of screen
    [pauseButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:pauseButton];
    
    //Add score Label to view
    scoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Verdana-Bold" fontSize:16.0f];
    scoreLabel.positionType = CCPositionTypeNormalized;
    scoreLabel.position = ccp(0.10f, 0.95f);
    
    [self addChild:scoreLabel];
    
    
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
    spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"helicopters.png"];
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
    
    //set minimum and maximum speeds of helicopter
    int minSpeed = 3.0;
    int maxSpeed = 5.0;
    int rangeDuration = maxSpeed - minSpeed;
    int actualSpeed = (arc4random() % rangeDuration) + minSpeed;
    
    
    CCActionMoveTo *moveHeli = [CCActionMoveTo actionWithDuration:actualSpeed position:ccp(-self.helicopter.contentSize.width/2, actualLoc)];
    
    //Run action of moving helicopter and Call block to remove helicsopter from parent when not in view.
    if (!sectionOneComplete) {
        
        [self tutorialPaused:1];
        
        sectionOneComplete = true;
    }
    
    
    [self.helicopter runAction:[CCActionSequence actions:moveHeli, [CCActionCallBlock actionWithBlock:^{
        
        
        misses--;
        
        [missedHelis setString:[NSString stringWithFormat:@"Misses: %d", misses]];
        
        //Remove helicopter from parent.
        
        CCNode *node = spriteSheet;
        [node removeFromParentAndCleanup:YES];
        
        //Set losing condition
        if (misses == 0) {
            CCScene *gameOver = [GameOverScene finalScore:0];
            [[CCDirector sharedDirector] replaceScene:gameOver];
        }
        
        
        
        if (!sectionThreeComplete) {
            if(misses < 3){
                [self tutorialPaused:3];
                
                sectionThreeComplete = true;
            }
        }
        
        
    }], nil]];
    
    
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
    
    if(missileCount > 0){
        
        //Get screne touches and locations
        //UITouch *touch = [touch anyObject];
        CGPoint touchLoc = [touch locationInNode:self];
        
        //Set screneSize to window or view size
        viewableArea = [[CCDirector sharedDirector] viewSize];
        //Set _missle sprite to shell image
        CCSprite *_missile = [CCSprite spriteWithImageNamed:@"shell.png"];
        
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
        CCActionMoveTo *launchMissle = [CCActionMoveTo actionWithDuration:duration position:destination];
        
        missileCount--;
        
        NSLog(@"MISSILE COUNT = %d", missileCount);
        
        //Run action of launching missile and Call block to remove missile from parent when not in view.
        [_missile runAction:[CCActionSequence actions:launchMissle, [CCActionCallBlock actionWithBlock:^{
            
            
            //Remove missile from parent
            
            CCNode *node = _missile;
            if (_missile.position.x > viewableArea.width) {
                [node removeFromParentAndCleanup:YES];
                NSLog(@"MISSILE REMOVED");
            }
            
            
        }], nil]];
        
        
        //[self removeChild:_missile];
        [[OALSimpleAudio sharedInstance] playBg:@"aexp2.wav" loop:NO];
        
        
        if(CGRectContainsPoint(_tank.textureRect, touchLoc)){
            
            [[OALSimpleAudio sharedInstance] playBg:@"tank_reload.mp3" loop:NO];
        }
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
                
                if (!sectionTwoComplete) {
                    [self tutorialPaused:2];
                    sectionTwoComplete = true;
                }
                
                //Increase hits
                hits++;
                
                //Multiply hits by 10 to get totalScore
                int scoreTotal = hits * 10;
                //Update ScoreLabel with string to include scoreTotal
                [scoreLabel setString:[NSString stringWithFormat:@"Score: %d", scoreTotal]];
                
                /*if (scoreTotal == 100) {
                    CCScene *gameOver = [GameOverScene winningScene:YES];
                    [[CCDirector sharedDirector] replaceScene:gameOver];
                }*/
                
                
                
                
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

-(void)tutorialPaused:(int)section
{
    if(section == 1)
    {
        [[CCDirector sharedDirector] pause];
        
        tutorialLabel = [CCLabelTTF labelWithString:@"Tap screen to launch missile" fontName:@"Verdana" fontSize:14.0f];
        tutorialLabel.positionType = CCPositionTypeNormalized;
        tutorialLabel.position = ccp(0.5f, 0.5f);
        tutorialLabel.color = [CCColor whiteColor];
        [self addChild:tutorialLabel];
        
        okayButton = [CCButton buttonWithTitle:@"Okay" fontName:@"Verdana" fontSize:16.0f];
        okayButton.positionType = CCPositionTypeNormalized;
        okayButton.position = ccp(0.80f, 0.15f);
        [okayButton setTarget:self selector:@selector(sectionOneResume:)];
        [self addChild:okayButton];
        
        [self removeAssets:1];
    }
    else if (section == 2)
    {
        [[CCDirector sharedDirector] pause];
        
        tutorialLabel = [CCLabelTTF labelWithString:@"Each hit will increase your score" fontName:@"Verdana" fontSize:14.0f];
        tutorialLabel.positionType = CCPositionTypeNormalized;
        tutorialLabel.position = ccp(0.5f, 0.5f);
        tutorialLabel.color = [CCColor whiteColor];
        [self addChild:tutorialLabel];
        
        okayButton = [CCButton buttonWithTitle:@"Okay" fontName:@"Verdana" fontSize:16.0f];
        okayButton.positionType = CCPositionTypeNormalized;
        okayButton.position = ccp(0.80f, 0.15f);
        [okayButton setTarget:self selector:@selector(sectionTwoResume:)];
        [self addChild:okayButton];
        
        [self removeAssets:2];
    }
    
    else if (section == 3)
    {
        [[CCDirector sharedDirector] pause];
        
        tutorialLabel = [CCLabelTTF labelWithString:@"You can only miss three helicopters or you will lose the game!" fontName:@"Verdana" fontSize:14.0f];
        tutorialLabel.positionType = CCPositionTypeNormalized;
        tutorialLabel.position = ccp(0.5f, 0.5f);
        tutorialLabel.color = [CCColor whiteColor];
        [self addChild:tutorialLabel];
        
        okayButton = [CCButton buttonWithTitle:@"Okay" fontName:@"Verdana" fontSize:16.0f];
        okayButton.positionType = CCPositionTypeNormalized;
        okayButton.position = ccp(0.80f, 0.15f);
        [okayButton setTarget:self selector:@selector(sectionThreeResume:)];
        [self addChild:okayButton];
        
        [self removeAssets:3];
    }
    
    
    else if (section == 4)
    {
        //Resume Game Animations
        [[CCDirector sharedDirector] pause];

        tutorialLabel = [CCLabelTTF labelWithString:@"You have successfully completed the tutorial. Have Fun!" fontName:@"Verdana" fontSize:14.0f];
        tutorialLabel.positionType = CCPositionTypeNormalized;
        tutorialLabel.position = ccp(0.5f, 0.5f);
        tutorialLabel.color = [CCColor whiteColor];
        [self addChild:tutorialLabel];
        
        okayButton = [CCButton buttonWithTitle:@"Okay" fontName:@"Verdana" fontSize:16.0f];
        okayButton.positionType = CCPositionTypeNormalized;
        okayButton.position = ccp(0.80f, 0.15f);
        [okayButton setTarget:self selector:@selector(sectionFourResume:)];
        [self addChild:okayButton];
        
        
    }
}

-(void)removeAssets:(int)section
{
    if (section == 1) {
        
        [self removeChild:pauseButton];
        [self removeChild:backButton];
        [self removeChild:missedHelis];
        [self removeChild:scoreLabel];
        
    }
    else if (section == 2){
        
        [self removeChild:pauseButton];
        [self removeChild:backButton];
        [self removeChild:missedHelis];
    }
    else if (section == 3)
    {
        [self removeChild:pauseButton];
        [self removeChild:backButton];
        [self removeChild:scoreLabel];
    }
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

-(void)sectionOneResume:(id)sender
{
    //Resume Game Animations
    [[CCDirector sharedDirector] resume];
    
    //Remove Resume Button
    [self removeChild:okayButton];
    [self removeChild:tutorialLabel];
    
    [self addChild:pauseButton];
    [self addChild:backButton];
    [self addChild:missedHelis];
    [self addChild:scoreLabel];
    
}

-(void)sectionTwoResume:(id)sender
{
    
    
    //Resume Game Animations
    [[CCDirector sharedDirector] resume];
    
    if(sectionThreeComplete){
        //Remove Resume Button
        [self removeChild:okayButton];
        [self removeChild:tutorialLabel];
        
        [self tutorialPaused:4];

        
    }else{
    

    //Remove Resume Button
    [self removeChild:okayButton];
    [self removeChild:tutorialLabel];
    
    [self addChild:pauseButton];
    [self addChild:backButton];
    [self addChild:missedHelis];
    }
}

-(void)sectionThreeResume:(id)sender
{
    //Resume Game Animations
    [[CCDirector sharedDirector] resume];
   
    if(sectionTwoComplete){
        
        //Remove Resume Button
        [self removeChild:okayButton];
        [self removeChild:tutorialLabel];
        
        [self tutorialPaused:4];
        

        
    }else{
        [self removeChild:okayButton];
        [self removeChild:tutorialLabel];
        
        [self addChild:pauseButton];
        [self addChild:backButton];
        [self addChild:scoreLabel];
    }
    
}

-(void)sectionFourResume:(id)sender
{
    //Resume Game Animations
    [[CCDirector sharedDirector] resume];
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end

