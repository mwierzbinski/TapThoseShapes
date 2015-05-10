//
//  TTSTriangle.m
//  TapThoseShapes
//
//  Created by Michal Wierzbinski on 09/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import "TTSTriangle.h"

@implementation TTSTriangle

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        _area = [self calculateArea];
    }
    
    return self;
}

#pragma mark - override

- (BOOL)containsPoint:(CGPoint)point {
    
    // get triangle points - hmm should we keep those in array?
    // were calculating them twice :/
    CGPoint pointA = CGPointMake(self.center.x - (self.size.width * .5), self.center.y - (self.size.width * .5));
    CGPoint pointB = CGPointMake(self.center.x + (self.size.width * .5), self.center.y - (self.size.width * .5));
    CGPoint pointC = CGPointMake(self.center.x, self.center.y + (self.size.width * .5));
    
    //calculate vectors
    CGVector v0 = CGVectorMake(pointC.x - pointA.x, pointC.y - pointA.y);
    CGVector v1 = CGVectorMake(pointB.x - pointA.x, pointB.y - pointA.y);
    CGVector v2 = CGVectorMake(point.x - pointA.x, point.y - pointA.y);
    
    // compute dot products
    float dot00 = [self dotProductWithVector:v0 andVector:v0];
    float dot01 = [self dotProductWithVector:v0 andVector:v1];
    float dot02 = [self dotProductWithVector:v0 andVector:v2];
    float dot11 = [self dotProductWithVector:v1 andVector:v1];
    float dot12 = [self dotProductWithVector:v1 andVector:v2];
    
    // Compute barycentric coordinates
    float invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
    float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
    float v = (dot00 * dot12 - dot01 * dot02) * invDenom;
    
    // Check if point is in triangle
    return (u >= 0) && (v >= 0) && (u + v < 1);
}

- (NSString *)shapeDescription {
    int sides = 3;
    return [NSString stringWithFormat:@"Triangle with numbero of sides: %i and area:%.1f",sides ,[self calculateArea]];
}

#pragma mark - calculation helpers

-(float)calculateArea {
    float h = self.size.height;
    float b = self.size.width;
    
    return .5 * (h * b);
}

-(float) dotProductWithVector:(CGVector)vectorA andVector:(CGVector)vectorB {
    
    return (vectorA.dx * vectorB.dx + vectorA.dy * vectorB.dy);
}


@end
