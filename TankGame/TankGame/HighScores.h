//
//  HighScores.h
//  TankGame
//
//  Created by Dale Tupling on 8/24/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HighScores : NSManagedObject

@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSNumber * score;

@end
