//
//  TTSGameView.h
//  TapThoseShapes
//
//  Created by Michal Wierzbinski on 10/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTSGameView : UIView

@property (retain, nonatomic) IBOutlet UIImageView *shapesField;


-(void)updateScreenWithObjects:(NSArray *)shapesArray;


@end
