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
static int kTimePerRound = 60;
static int kInitialShapesCount = 20; // the number will be a random between kMinNodes and (kMinNodes + kInitialShapesCount)

@interface ViewController ()

@property (nonatomic, retain) NSTimer *levelTimer;
@property (nonatomic, retain) NSTimer *spawnTimer;
@property (nonatomic, retain) UITextView *infoText;
@property (nonatomic, retain) TTSLevel *level;

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
    [_infoText release];
    [_level release];
    [super dealloc];
}

#pragma mark - observers

-(void) addObservers {
    
    NSString *gameStateKey = NSStringFromSelector(@selector(gameState));
    [self.level addObserver:self forKeyPath:gameStateKey options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObservers {
    
    NSString *gameStateKey = NSStringFromSelector(@selector(gameState));
    [self.level removeObserver:self forKeyPath:gameStateKey];
    

}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *gameStateKey = NSStringFromSelector(@selector(gameState));
    NSString *shapeListKey = NSStringFromSelector(@selector(shapeList));
    
    if (object == self.level && [keyPath isEqualToString:shapeListKey]) {
        [[self getGameView] updateScreenWithObjects:self.level.shapeList];
        
    } else if (object == self.level && [keyPath isEqualToString:gameStateKey]) {
        
        if (self.level.gameState == TTSGameStateInProgress) {
            [self startGame];
        } else if (self.level.gameState == TTSGameStateStart) {
            [self showIntroScreen];
        } else if (self.level.gameState == TTSGameStateEnd) {
            [self endGame];
        }
        
    } else {
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
    
    self.level.gameState = TTSGameStateStart;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedScreen:)];
    [[self getGameView].shapesField addGestureRecognizer:tap];
    [tap release];
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

#pragma mark - game

- (void)startGame {
    
    [self.infoText removeFromSuperview];
    self.infoText = nil;
    
    // add observer for shapelist
    NSString *shapeListKey = NSStringFromSelector(@selector(shapeList));
    [self.level addObserver:self forKeyPath:shapeListKey options:NSKeyValueObservingOptionNew context:nil];
    
    // customize level
    self.level.minShapes = kMinNodes;
    self.level.maxShapes = kMaxNodes;
    self.level.timeLeftInRound = kTimePerRound;
    self.level.initialShapesCount = arc4random_uniform(kInitialShapesCount) + kMinNodes;
    [self.level populateLevel];
    
    // start game timers
    NSTimer* levelTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateRemainingTime:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:levelTimer forMode:NSRunLoopCommonModes];
    self.levelTimer = levelTimer;
    
    NSTimer* spawnTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateShapes:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:spawnTimer forMode:NSRunLoopCommonModes];
    self.spawnTimer = spawnTimer;
    
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
    [self.spawnTimer invalidate];
    self.spawnTimer = nil;
    
    [self.levelTimer invalidate];
    self.levelTimer = nil;
    
    // remove observers
    NSString *shapeListKey = NSStringFromSelector(@selector(shapeList));
    [self.level removeObserver:self forKeyPath:shapeListKey];
}

- (void)updateRemainingTime:(NSTimer *)onject {
    
}

- (void)updateShapes:(NSTimer *)onject {
    [self.level addRandomShapeToList];
}

-(void)dismissInfoScreen:(UITapGestureRecognizer *)tapGesture {
    
    if (self.level.gameState == TTSGameStateStart || self.level.gameState == TTSGameStateEnd) {
        self.level.gameState = TTSGameStateInProgress;
    }
}

-(void) showIntroScreen {
    self.infoText = [self setupInfoText];
    self.infoText.text = @"[ Tap to start ]";
    [self.view addSubview:self.infoText];
}

-(void)showEndGameScreen {
    self.infoText = [self setupInfoText];
    self.infoText.text = @"[ Tap to try again ]";
    [self.view addSubview:self.infoText];
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
    
    // Start with a blank transform
    //CATransform3D blankTransform = CATransform3DIdentity;
    
    // Skew the text
    // blankTransform.m34 = -1.0 / 700.0;
    
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
