//
//  TTSLevel.h
//  TapThoseShapes
//
//  Created by Michal Wierzbinski on 09/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSShape.h"
#import "TTSCircle.h"
#import "TTSSquare.h"
#import "TTSTriangle.h"

// currently there is one level but
// if there will be time we could change this to properties of the level
// so the levels would differ

static NSInteger kNoStartingShapes = 20; // number of Shapes you start with on the lvl
static NSInteger kMinNodes = 10; // minimum number of Shapes at this lvl
static NSInteger kMaxNodes = 200; // max number of Shapes at this lvl
static NSInteger kTimeInterval = 1; // spawning time of Shapes

@interface TTSLevel : NSObject

@property (nonatomic, retain) NSArray *shapeList;

- (void)initializeLevel; //should be called after we set level properties
- (void)removeShapeFromList:(TTSShape *)shape;

@end
