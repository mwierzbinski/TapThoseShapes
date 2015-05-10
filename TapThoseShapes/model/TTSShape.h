//
//  TTSShape.h
//  TapThoseShapes
//
//  Created by Michal Wierzbinski on 09/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, STShapeType)
{
    STShapeTypeCircle = 1,
    STShapeTypeSquare,
    STShapeTypeTriangle
    
};

@interface TTSShape : NSObject {
    float _area;
}

@property(nonatomic, assign, readonly) CGSize size;
@property(nonatomic, assign) CGPoint center;

- (instancetype)initWithSize:(CGSize)size;
- (NSString *)shapeDescription;
- (BOOL)containsPoint:(CGPoint)point;

@end
