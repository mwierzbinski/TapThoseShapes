//
//  ViewController.m
//  TapThoseShapes
//
//  Created by Michal Wierzbinski on 10/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import "ViewController.h"

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
    [_level release];
    [super dealloc];
}

#pragma mark - setup model

- (void)setupData {
    
    TTSLevel *level = [[TTSLevel alloc] init];
    [level initializeLevel];
    self.level = level;
    [level release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
