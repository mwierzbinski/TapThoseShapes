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

typedef NS_ENUM(NSUInteger, TTSGameState)
{
    TTSGameStateStart = 1,
    TTSGameStateInProgress,
    TTSGameStateEnd
    
};

@interface TTSLevel : NSObject

@property (nonatomic, retain) NSArray *shapeList;
@property (nonatomic, assign) NSInteger timeLeftInRound;
@property (nonatomic, assign) NSInteger minShapes;
@property (nonatomic, assign) NSInteger maxShapes;
@property (nonatomic, assign) NSInteger initialShapesCount;
@property (nonatomic, assign) TTSGameState gameState;

- (void)populateLevel; //should be called after we set level properties
- (void)depopulateLevel;
- (void)removeShapeFromList:(TTSShape *)shape;
- (void)addRandomShapeToList;


@end
