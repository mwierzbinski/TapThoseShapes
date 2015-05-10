//
//  TTSLevel.m
//  TapThoseShapes
//
//  Created by Michal Wierzbinski on 09/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import "TTSLevel.h"

static float kMinShapeSize = 44; // we could make it small but that would be difficult to hit with a finger ;)

@implementation TTSLevel

#pragma mark - init/dealoc

- (void)dealloc {
    [_shapeList release];
    [super dealloc];
}

- (void)initializeLevel {
    
    NSMutableArray *initialShapesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < kNoStartingShapes; i++) {
        [initialShapesArray addObject:[self createRandomShape]];
    }
    
    //making sure if were not adding empty array
    self.shapeList = [initialShapesArray count] > 0 ? initialShapesArray : nil;
    
    [initialShapesArray release];
}

#pragma mark - adding/ removing from list

- (void)removeShapeFromList:(TTSShape *)shape
{
    NSMutableArray *tempShapesArray = [[NSMutableArray alloc] initWithArray:self.shapeList];
    [tempShapesArray removeObject:shape];
    self.shapeList = tempShapesArray;
    [tempShapesArray release];
}

#pragma mark - creating shapes

- (TTSShape *)createRandomShape {
    
    TTSShape *randomShape = nil;
    
    // randomize type
    STShapeType shapeType = arc4random_uniform(3) + 1; // there are 3 types of shapes
    
    // randomize size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int maxSize = screenRect.size.width * .2; // there is no point in making the shapes too big.
    float side = arc4random_uniform(maxSize) + kMinShapeSize;
    
    CGSize randomSize = CGSizeMake(side, side); // we want squares and circles, not rectangles and elipses.

    switch (shapeType) {
        case STShapeTypeCircle:
            randomShape = [[TTSCircle alloc] initWithSize:randomSize];
            break;
        case STShapeTypeSquare:
            randomShape = [[TTSSquare alloc] initWithSize:randomSize];
            break;
        case STShapeTypeTriangle:
            randomShape = [[TTSTriangle alloc] initWithSize:randomSize];
            break;
    }
    
    // randomize position
    // making sure the shape will not go out of screen.. too much
    float minDistanceFromBorder = side * 0.5;
    float maxDistanceX = screenRect.size.width - (minDistanceFromBorder * 2);
    float maxDistanceY = screenRect.size.height - (minDistanceFromBorder * 2);
    
    float x = arc4random_uniform(maxDistanceX) + minDistanceFromBorder;
    float y = arc4random_uniform(maxDistanceY) + minDistanceFromBorder;
    CGPoint randomCenter = CGPointMake(x, y);
    randomShape.center = randomCenter;
    
    // add radnom color
    randomShape.color = [self randomColor];
    
    return [randomShape autorelease];
}

-(UIColor *)randomColor {
    
    float red = arc4random_uniform(100) / 100.0f;
    float green = arc4random_uniform(100) / 100.0f;
    float blue = arc4random_uniform(100) / 100.0f;
    float alpha = 1.0f;
    
    UIColor *randomColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:alpha];
    
    return [randomColor autorelease];
}

@end
