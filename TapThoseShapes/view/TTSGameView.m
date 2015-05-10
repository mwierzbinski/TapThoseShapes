//
//  TTSGameView.m
//  TapThoseShapes
//
//  Created by Michal Wierzbinski on 10/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import "TTSGameView.h"
#import "TTSShape.h"
#import "TTSSquare.h"
#import "TTSCircle.h"
#import "TTSTriangle.h"

@implementation TTSGameView

#pragma mark - init/dealloc

- (void)dealloc {
    [_shapesField release];
    [super dealloc];
}

-(void)updateScreenWithObjects:(NSArray *)shapesArray {

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float width = screenRect.size.width;
    float height = screenRect.size.height;
    
    // create a new bitmap image context at the device resolution (retina/non-retina)
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), false, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // push context to make it current
    // (need to do this manually because we are not drawing in a UIView)
    UIGraphicsPushContext(context);

    for (TTSShape *shape in shapesArray) {
        UIImage *textureImg = nil;// input image to be composited over new image as example
        
        if ([shape isKindOfClass:[TTSCircle class]]) {
            // draw circle img
            textureImg = [self drawCircleShape:shape];
            
        } else if ([shape isKindOfClass:[TTSSquare class]]) {
            // draw square img
            textureImg = [self drawSquareShape:shape];
            
        } else if ([shape isKindOfClass:[TTSTriangle class]]) {
            // draw triangle img
            textureImg = [self drawTriangleShape:shape];
        }
        
        float shapePosX = shape.center.x - (shape.size.width * .5);
        float shapePosY = shape.center.y - (shape.size.height * .5);
        [textureImg drawAtPoint:CGPointMake(shapePosX, shapePosY)];
    }
    
    // pop context
    UIGraphicsPopContext();
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    self.shapesField.image = outputImage;
}


#pragma mark - touch



#pragma mark - drawing methods

-(UIImage *)drawTriangleShape:(TTSShape *)shape {
    
    CGSize shapeSize = shape.size;
    
    // create drawing context
    UIGraphicsBeginImageContextWithOptions(shapeSize, false, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw triangle
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, shapeSize.height);  // top left
    CGContextAddLineToPoint(context, shapeSize.width * 0.5, 0);  // mid right
    CGContextAddLineToPoint(context, shapeSize.width, shapeSize.height);  // bottom left
    CGContextClosePath(context);
    // fill color
    CGContextSetFillColorWithColor(context, shape.color.CGColor);
    CGContextFillPath(context);
    
    // extract image
    UIImage *spriteImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return spriteImage;
}

-(UIImage *)drawCircleShape:(TTSShape *)shape {
    
    CGSize shapeSize = shape.size;
    
    // create drawing context
    UIGraphicsBeginImageContextWithOptions(shapeSize, false, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw circle
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, shape.color.CGColor);
    CGRect borderRect = CGRectMake(0.0, 0.0, shapeSize.width, shapeSize.height);
    CGContextFillEllipseInRect (context, borderRect);
    CGContextFillPath(context);
    
    // extract image
    UIImage *spriteImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return spriteImage;
}

-(UIImage *)drawSquareShape:(TTSShape *)shape {
    
    CGSize shapeSize = shape.size;
    
    // create drawing context
    UIGraphicsBeginImageContextWithOptions(shapeSize, false, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw square
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, shape.color.CGColor);
    CGRect borderRect = CGRectMake(0.0, 0.0, shapeSize.width, shapeSize.height);
    CGContextFillRect(context, borderRect);
    CGContextFillPath(context);
    
    // extract image
    UIImage *spriteImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return spriteImage;
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
