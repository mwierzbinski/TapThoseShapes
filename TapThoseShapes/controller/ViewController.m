//
//  ViewController.m
//  TapThoseShapes
//
//  Created by Michal Wierzbinski on 10/05/2015.
//  Copyright (c) 2015 WheelReinvented. All rights reserved.
//

#import "ViewController.h"
#import "TTSGameView.h"
#import "TTSLevel.h"

// defined values for task
static int kMinNodes = 10; // minimum number of Shapes at this lvl
static int kMaxNodes = 200; // max number of Shapes at this lvl
static int kTimePerRound = 10;
static int kInitialShapesCount = 20; // the number will be a random between kMinNodes and (kMinNodes + kInitialShapesCount)
static int kUpdateCallsPerSecond = 60;
static double kShapeSpawnTime = .5; // adding new shape every .5s
static double kDescriptionLabelDismissTime = 2.f;

@interface ViewController () {
    double addShapeTime;
    double roundClock;
    double shapeDescTime;
    // double lastUpdateTime;
}

@property (nonatomic, retain) NSTimer *updateTimer;
@property (nonatomic, retain) UITextView *infoText;
@property (nonatomic, retain) TTSLevel *level;
@property (nonatomic, assign) TTSGameState gameState;

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
    [_updateTimer invalidate];
    [_updateTimer release];
    [_infoText release];
    [_level release];
    [super dealloc];
}

#pragma mark - observers

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *shapeListKey = NSStringFromSelector(@selector(shapeList));
    NSString *roundTimeKey = NSStringFromSelector(@selector(timeLeftInRound));
    
    if (object == self.level && [keyPath isEqualToString:shapeListKey]) {
        [[self getGameView] updateScreenWithObjects:self.level.shapeList];
        
    } else if (object == self.level && [keyPath isEqualToString:roundTimeKey]) {
        [self getGameView].timerLabel.text = [NSString stringWithFormat:@"%li", (long)self.level.timeLeftInRound];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - setup model

- (void)setupData {
    
    TTSLevel *level = [[TTSLevel alloc] init];
    self.level = level;
    [level release];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameState = TTSGameStateStart;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedScreen:)];
    [[self getGameView].shapesField addGestureRecognizer:tap];
    [tap release];
}

-(void)tapedScreen:(UITapGestureRecognizer *)tapGesture {
    CGPoint tapPoint = [tapGesture locationInView:tapGesture.view];

    for (long i = [self.level.shapeList count] -1; i >= 0; i--) {
        
        TTSShape *shape = [self.level.shapeList objectAtIndex:i];

        if ([shape containsPoint:tapPoint]) {
            [self showShapeDescription:[shape shapeDescription]];
            [self.level removeShapeFromList:shape];
            break;
        }
    }
}

#pragma mark - game

- (void)startGame {
    
    [self.infoText removeFromSuperview];
    self.infoText = nil;
    
    // add observer for shapelist
    NSString *shapeListKey = NSStringFromSelector(@selector(shapeList));
    [self.level addObserver:self forKeyPath:shapeListKey options:NSKeyValueObservingOptionNew context:nil];

    NSString *roundTimeKey = NSStringFromSelector(@selector(timeLeftInRound));
    [self.level addObserver:self forKeyPath:roundTimeKey options:NSKeyValueObservingOptionNew context:nil];
    
    // customize level
    self.level.minShapes = kMinNodes;
    self.level.maxShapes = kMaxNodes;
    self.level.timeLeftInRound = kTimePerRound;
    self.level.initialShapesCount = arc4random_uniform(kInitialShapesCount) + kMinNodes;
    [self.level populateLevel];
    
    // start game timers
    addShapeTime = 0;
    roundClock = 0;
    // lastUpdateTime = [[NSDate date] timeIntervalSince1970];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f/kUpdateCallsPerSecond target:self selector:@selector(updateGame:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.updateTimer = timer;
    
}

- (void)endGame {
    
    [self showEndGameScreen];
    
    //remove shapes
    self.level.minShapes = 0;
    self.level.maxShapes = 0;
    self.level.timeLeftInRound = 0;
    self.level.initialShapesCount = 0;
    [self.level depopulateLevel];

    // invalidate timers
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    
    // remove observers
    NSString *shapeListKey = NSStringFromSelector(@selector(shapeList));
    [self.level removeObserver:self forKeyPath:shapeListKey];
    
    NSString *roundTimeKey = NSStringFromSelector(@selector(timeLeftInRound));
    [self.level removeObserver:self forKeyPath:roundTimeKey];
}

#pragma mark - actions

- (void)updateGame:(NSTimer *)timer {
    // not using this to update views.
    // We could, but in this app redrawing everything in each frame is not necessary (i think).
    // instead were using observers to update view when necessary
    
    // calculate delta time - should be improved for now using timers timeInterval should be enough.
    //    double newTime = [[NSDate date] timeIntervalSince1970];
    //    double dt = newTime - lastUpdateTime;
    // lastUpdateTime = newTime;
    
    // add shape every kShapeSpawnTime
    [self updateShapes:timer.timeInterval];
    // update game clock
    [self updateRemainingTime:timer.timeInterval];
    // update botton label timer
    [self updateShapeDescription:timer.timeInterval];
    
}

- (void)updateRemainingTime:(double)deltaTime {
    
    float sec = 1.f;
    roundClock += deltaTime;
    
    if (roundClock >= sec) {
        --self.level.timeLeftInRound;
        if (self.level.timeLeftInRound == 0) {
            self.gameState = TTSGameStateEnd;
        }
        
        roundClock = 0;
    }
}

- (void)updateShapes:(double)deltaTime {
    
    addShapeTime += deltaTime;
    if (addShapeTime >= kShapeSpawnTime) {
        [self.level addRandomShapeToList];
        addShapeTime = 0;
    }
}

-(void)dismissInfoScreen:(UITapGestureRecognizer *)tapGesture {
    
    if (self.gameState == TTSGameStateStart || self.gameState == TTSGameStateEnd) {
        self.gameState = TTSGameStateInProgress;
    }
}

-(void)showIntroScreen {
    self.infoText = [self setupInfoText];
    self.infoText.text = @"[ Tap to start ]";
    [self.view addSubview:self.infoText];
}

-(void)showEndGameScreen {
    self.infoText = [self setupInfoText];
    self.infoText.text = @"[ Tap to try again ]";
    [self.view addSubview:self.infoText];
}

-(void)showShapeDescription:(NSString *)description {
    shapeDescTime = 0;
    [self getGameView].descriptionLabel.text = description;
}

-(void)updateShapeDescription:(double)deltaTime {
    shapeDescTime += deltaTime;
    if (shapeDescTime >= kDescriptionLabelDismissTime) {
        [self getGameView].descriptionLabel.text = @"";
        shapeDescTime = 0;
    }
}

#pragma mark - 

-(void)setGameState:(TTSGameState)gameState {
    
    _gameState = gameState;
    
    if (gameState == TTSGameStateInProgress) {
        [self startGame];
    } else if (gameState == TTSGameStateStart) {
        [self showIntroScreen];
    } else if (gameState == TTSGameStateEnd) {
        [self endGame];
    }
}

#pragma mark - info screen

-(UITextView *)setupInfoText {
    
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.backgroundColor = [UIColor blackColor];
    textView.textColor = [UIColor yellowColor];
    textView.font = [UIFont boldSystemFontOfSize:36.0];
    textView.textAlignment = NSTextAlignmentCenter;
    
    // disable editing
    textView.editable = NO;
    textView.selectable = NO;
    
    // add gesture for dismiss
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInfoScreen:)];
    [textView addGestureRecognizer:tap];
    [tap release];
    
    // because star wars is cool!
    // Start with a blank transform
    // CATransform3D blankTransform = CATransform3DIdentity;
    
    // Skew the text
    // blankTransform.m34 = -1.0 / 800.0;
    
    // Rotate the text
    // blankTransform = CATransform3DRotate(blankTransform, 45.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
    
    // Set the transform
    // [textView.layer setTransform:blankTransform];
    
    return [textView autorelease];
}

#pragma mark - helper

-(TTSGameView *) getGameView {
    return (TTSGameView *)self.view;
}

@end
