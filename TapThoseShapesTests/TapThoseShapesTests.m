//
//  TapThoseShapesTests.m
//  TapThoseShapesTests
//
//  Created by Michal Wierzbinski on 10/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TTSCircle.h"
#import "TTSSquare.h"
#import "TTSTriangle.h"

@interface TapThoseShapesTests : XCTestCase

@end

@implementation TapThoseShapesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatCircleReturnsProperDescription
{
    // given
    CGSize boundingBox = CGSizeMake(1, 1);
    TTSCircle *circle = [[TTSCircle alloc] initWithSize:boundingBox];
    
    // when
    NSString *shapeDescription = [circle shapeDescription];
    
    // then
    XCTAssertEqualObjects(shapeDescription, @"Circle with radius: 0.5 and area: 0.8");

}

- (void)testThatTriangleReturnsProperDescription
{
    // given
    CGSize boundingBox = CGSizeMake(1, 1);
    TTSTriangle *triangle = [[TTSTriangle alloc] initWithSize:boundingBox];
    
    // when
    NSString *shapeDescription = [triangle shapeDescription];
    
    // then
    XCTAssertEqualObjects(shapeDescription, @"Triangle with sides: 3 and area: 0.5");
}

- (void)testThatSquareReturnsProperDescription
{
    // given
    CGSize boundingBox = CGSizeMake(1, 1);
    TTSSquare *triangle = [[TTSSquare alloc] initWithSize:boundingBox];
    
    // when
    NSString *shapeDescription = [triangle shapeDescription];
    

    // then
    XCTAssertEqualObjects(shapeDescription, @"Square with sides: 4 and area: 1.0");
}
@end
