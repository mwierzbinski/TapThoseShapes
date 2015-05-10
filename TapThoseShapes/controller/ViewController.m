//
//  ViewController.m
//  TapThoseShapes
//
//  Created by Michal Wierzbinski on 10/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import "ViewController.h"
#import "TTSGameView.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - init/dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    // just in case someone would want to get rid of storyboard
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setupData];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    // because this app uses storyboards, this method will be called
    
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupData];
    }
    return self;
}

- (void)dealloc {
    [self removeObservers];
    [_level release];
    [super dealloc];
}

#pragma mark - observers

-(void) addObservers {
    NSString *shapeListKey = NSStringFromSelector(@selector(shapeList));
    [self.level addObserver:self forKeyPath:shapeListKey options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObservers {
    NSString *shapeListKey = NSStringFromSelector(@selector(shapeList));
    [self.level removeObserver:self forKeyPath:shapeListKey];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *shapeListKey = NSStringFromSelector(@selector(shapeList));
    if (object == self.level && [keyPath isEqualToString:shapeListKey])
    {
        [[self getGameView] updateScreenWithObjects:self.level.shapeList];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - setup model

- (void)setupData {
    
    TTSLevel *level = [[TTSLevel alloc] init];
    self.level = level;
    [level release];
    
    [self addObservers];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.multipleTouchEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedScreen:)];
    [[self getGameView].shapesField addGestureRecognizer:tap];
    [tap release];
    
    [self.level initializeLevel];
}

-(void)tapedScreen:(UITapGestureRecognizer *)tapGesture {
    CGPoint tapPoint = [tapGesture locationInView:tapGesture.view];

    for (long i = [self.level.shapeList count] -1; i >= 0; i--) {
        
        TTSShape *shape = [self.level.shapeList objectAtIndex:i];

        if ([shape containsPoint:tapPoint]) {
            [self.level removeShapeFromList:shape];
            break;
        }
    }
}

#pragma mark - helper

-(TTSGameView *) getGameView {
    return (TTSGameView *)self.view;
}

@end
