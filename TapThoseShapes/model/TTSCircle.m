//
//  TTSCircle.m
//  TapThoseShapes
//
//  Created by Michal Wierzbinski on 09/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import "TTSCircle.h"

@implementation TTSCircle

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        _radius = self.size.width * .5;
        _area = [self calculateArea];
    }
    
    return self;
}

#pragma mark - override

- (BOOL)containsPoint:(CGPoint)point {
    
    float distanceX = (self.center.x - point.x) * (self.center.x - point.x);
    float distanceY = (self.center.y - point.y) * (self.center.y - point.y);
    
    return distanceX + distanceY < _radius * _radius;
}

- (NSString *)shapeDescription {
    
    return [NSString stringWithFormat:@"Circle with radius: %.0f and area: %.0f", _radius, _area];
}

#pragma mark - calculation helpers

-(float)calculateArea {

    return _radius * _radius * M_PI;
}


@end
