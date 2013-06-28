//
//  BCRootViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 6/9/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCRootViewController.h"

@interface BCRootViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIView *timerBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *nextContractionEstimateLabel;

@property (nonatomic, strong)  BCContraction *activeContraction;

@property (nonatomic, strong) NSTimer *secondTimer;
@property (assign, nonatomic) NSTimeInterval secondsIntoContraction;

@end

@implementation BCRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.timerLabel.text = @"";
    self.timerLabel.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:self.timerLabel.font.pointSize];
    self.nextContractionEstimateLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:self.nextContractionEstimateLabel.font.pointSize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appForegroundNotification:) name:kForegroundingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBackgroundNotification:) name:kBackgroundingNotification object:nil];
    [self updateAppearanceState];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self updateDisappearanceState];
}

- (void)appForegroundNotification:(NSNotification *)note
{
    [self updateAppearanceState];
}

- (void)appBackgroundNotification:(NSNotification *)note
{
    [self updateDisappearanceState];
}

- (void)updateAppearanceState
{
    [self clearTimer];
    self.activeContraction = [BCContraction activeContraction];
    if(nil != self.activeContraction)
    {
        self.secondsIntoContraction = [[NSDate date] timeIntervalSinceDate:self.activeContraction.startTime];
        [self.startStopButton setTitle:@"End Contraction" forState:UIControlStateNormal];
        self.secondTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(secondTimerIncremented:) userInfo:nil repeats:YES];
    }
    [self updateViewState];
}

- (void)updateDisappearanceState
{
    [self clearTimer];
}

- (void)updateViewState
{
    [self updateTimerLabel];
}

- (void)updateTimerLabel
{
    self.timerLabel.text = [NSString stringWithFormat:@"%02i:%02i",(int)self.secondsIntoContraction / 60, (int)self.secondsIntoContraction % 60];
}

- (void)clearTimer
{
    if([self.secondTimer isValid])
    {
        [self.secondTimer invalidate];
    }
    
    self.secondTimer = nil;
}

- (void)secondTimerIncremented:(NSTimer *)timer
{
    self.secondsIntoContraction += 1;
    [self updateTimerLabel];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopContraction:(id)sender
{
    [self clearTimer];
    
    if(nil == self.activeContraction)
    {
        self.secondsIntoContraction = 0;
        //there is no active contraction so they were in rest
        //so start one
        self.activeContraction = [BCContraction createEntity];
        self.activeContraction.startTime = [NSDate date];
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
        [self.startStopButton setImage:[UIImage imageNamed:@"stop-button"] forState:UIControlStateNormal];
        self.timerBackgroundView.backgroundColor = [[UIColor colorWithHexString:kMidOrangeColor] colorWithAlphaComponent:.15];
        self.nextContractionEstimateLabel.hidden = YES;
        
        self.secondTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(secondTimerIncremented:) userInfo:nil repeats:YES];
        self.timerLabel.text = @"00:00";
    }
    else
    {
        //there was an active contraction so stop it
        self.activeContraction.endTime = [NSDate date];
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
        self.activeContraction = nil;
        [self.startStopButton setImage:[UIImage imageNamed:@"start-button"] forState:UIControlStateNormal];
        self.timerBackgroundView.backgroundColor = [[UIColor colorWithHexString:kDarkGreenColor] colorWithAlphaComponent:.1];
        self.nextContractionEstimateLabel.hidden = NO;
        self.timerLabel.text = @"";
    }
    
    [self updateViewState];
}

@end
