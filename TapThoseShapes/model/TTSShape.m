//
//  TTSShape.m
//  TapThoseShapes
//
//  Created by Michal Wierzbinski on 09/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import "TTSShape.h"

@implementation TTSShape

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _size = size;
    }
    
    return self;
}

- (void)dealloc {
    [_color release];
    [super dealloc];
}

- (NSString *)shapeDescription {
    return nil;
}

- (BOOL)containsPoint:(CGPoint)point {
    return NO;
}

@end
