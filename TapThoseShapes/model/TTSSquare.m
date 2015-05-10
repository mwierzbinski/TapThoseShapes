//
//  TTSSquare.m
//  TapThoseShapes
//
//  Created by Michal Wierzbinski on 09/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import "TTSSquare.h"

@implementation TTSSquare

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        _area = [self calculateArea];
    }
    
    return self;
}

#pragma mark - override

- (BOOL)containsPoint:(CGPoint)point {
    
    float distanceX = fabs(self.center.x - point.x);
    float distanceY = fabs(self.center.y - point.y);
    
    return distanceX < self.size.width * .5 && distanceY < self.size.height * .5;
}

- (NSString *)shapeDescription {
    int sides = 4;
    return [NSString stringWithFormat:@"Square with sides: %i and area: %.1f",sides ,_area];
}

#pragma mark - calculation helpers

-(float)calculateArea {
    return self.size.width * self.size.height;
}

@end
