//
//  BCRootViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 6/9/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCRootViewController.h"
#import "BCAveragesViewController.h"
#import "BCHistoryViewController.h"

@interface BCRootViewController ()

//timer section
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIView *timerBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *nextContractionEstimateLabel;

//Last Contraction
@property (weak, nonatomic) IBOutlet UIView *lastContractionContainerView;
@property (weak, nonatomic) IBOutlet UILabel *lastContractionLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *intensityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequencyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *intensityLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *lastContractionHandle;
@property (weak, nonatomic) IBOutlet UIView *lastContractionSlideOut;
@property (weak, nonatomic) IBOutlet UIView *lastContractionIntensityContainerView;

//inspirational

@property (weak, nonatomic) IBOutlet UILabel *inspirationalLabel;

//data
@property (nonatomic, strong)  BCContraction *activeContraction;
@property (nonatomic, strong) NSTimer *secondTimer;
@property (assign, nonatomic) NSTimeInterval secondsIntoContraction;
@property (assign, nonatomic) NSTimeInterval secondsUntilNextContraction;

//sub view controllers
@property (weak, nonatomic) IBOutlet UIView *historyContainerView;
@property (weak, nonatomic) IBOutlet UIView *averagesContainerView;
@property (strong, nonatomic) BCAveragesViewController *averagesController;
@property (strong, nonatomic) BCHistoryViewController *historyController;

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
    
    self.inspirationalLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:self.inspirationalLabel.font.pointSize];
    self.inspirationalLabel.alpha = 0.0;
    
    for(UILabel *titleLabel in @[self.nextContractionEstimateLabel, self.lastContractionLabel])
    {
        titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:titleLabel.font.pointSize];
    }
    
    for(UILabel *titleLabel in @[self.durationTitleLabel, self.intensityTitleLabel, self.frequencyTitleLabel])
    {
        titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:titleLabel.font.pointSize];
    }
    
    for(UILabel *valueLabel in @[self.durationLabel, self.intensityLabel, self.frequencyLabel])
    {
        valueLabel.font = [UIFont fontWithName:@"OpenSans" size:valueLabel.font.pointSize];
    }
    
    self.averagesController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"AveragesController"];
    [self addChildViewController:self.averagesController];
    self.averagesController.view.frame = self.averagesContainerView.frame;
    [self.view addSubview:self.averagesController.view];
    
    self.historyController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"HistoryController"];
    [self addChildViewController:self.historyController];
    self.historyController.view.frame = self.historyContainerView.frame;
    [self.view addSubview:self.historyController.view];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lastContractionHandleTapped:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(lastContractionHandlePanned:)];
    //UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lastContractionSwiped:)];
    //[swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.lastContractionHandle addGestureRecognizer:tapGesture];
    [self.lastContractionHandle addGestureRecognizer:panGesture];
    //[self.lastContractionContainerView addGestureRecognizer:swipeGesture];
    
    if(0 == [BCContraction countOfEntities])
    {
        //hide the last contraction thumb if we don't have any contractions yet
        [self.lastContractionSlideOut setFrameXOrigin:kSliderHiddenXCoordinate];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appForegroundNotification:) name:kForegroundingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBackgroundNotification:) name:kBackgroundingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contractionDeletedNotification:) name:kContractionDeletedNotification object:nil];
    [self updateAppearanceState];
    [self updateLastContractionView];
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

#pragma mark -
#pragma mark View Updates

- (void)updateAppearanceState
{
    [self clearTimer];
    self.activeContraction = [BCContraction activeContraction];
    self.secondTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(secondTimerIncremented:) userInfo:nil repeats:YES];
    if(nil != self.activeContraction)
    {
        self.secondsIntoContraction = [[NSDate date] timeIntervalSinceDate:self.activeContraction.startTime];
        [self.startStopButton setImage:[UIImage imageNamed:@"stop-button"] forState:UIControlStateNormal];
    }
    else
    {
        self.secondsUntilNextContraction = [BCContraction estimatedTimeUntilNextContraction];
        [self.startStopButton setImage:[UIImage imageNamed:@"start-button"] forState:UIControlStateNormal];
    }
    
    [self updateViewState];
}

- (void)updateLastContractionView
{
    BCContraction *lastContraction = [BCContraction lastContraction];
    self.durationLabel.text = [BCTimeIntervalFormatter timeStringForInterval:lastContraction.duration];
    self.frequencyLabel.text = [BCTimeIntervalFormatter timeStringForInterval:lastContraction.frequency];
    self.intensityLabel.text = lastContraction.intensity.intValue > 0 ? lastContraction.intensity.stringValue : @"-";
    
    for(UIButton *intensityButton in self.lastContractionIntensityContainerView.subviews)
    {
        intensityButton.enabled = [intensityButton titleForState:UIControlStateNormal].intValue != lastContraction.intensity.intValue;
    }
    
    
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
    if(nil != self.activeContraction)
    {
        //active contraction so show seconds in
        if(self.secondsIntoContraction > 0)
        {
            self.timerLabel.text = [BCTimeIntervalFormatter timeStringForInterval:self.secondsIntoContraction];
        }
    }
    else
    {
        self.timerLabel.text = [BCTimeIntervalFormatter timeStringForInterval:self.secondsUntilNextContraction];
    }
}

#pragma mark -
#pragma mark Gesture Handling

- (void)lastContractionHandleTapped:(UITapGestureRecognizer *)tapGesture
{
    [self toggleLastContractionSliderState:YES];
}

- (void)toggleLastContractionSliderState:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.3 : 0.0 animations:^{
        if(self.lastContractionSlideOut.frame.origin.x >= 0)
        {
            [self.lastContractionSlideOut setFrameXOrigin:kSliderThumbShownXCoordinate];
        }
        else
        {
            [self.lastContractionSlideOut setFrameXOrigin:kSliderShownXCoordinate];
        }
    }];
}

- (void)lastContractionHandlePanned:(UIPanGestureRecognizer *)panGesture
{
    static CGFloat originalGesturePosition = 0;
    static CGFloat lastGesturePosition = 0;
    if(panGesture.state == UIGestureRecognizerStateBegan)
    {
        originalGesturePosition = self.lastContractionSlideOut.frame.origin.x;
    }
    else if(panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [panGesture translationInView:self.view];
        lastGesturePosition = originalGesturePosition + translation.x;
        [self.lastContractionSlideOut setFrameXOrigin:lastGesturePosition];
    }
    else
    {
        //get velocity to complete at that velocity or distance based velocity (if they are moving slowly)
        CGPoint velocity = [panGesture velocityInView:self.view];
        CGFloat newFrameXOrigin = 0;
        CGFloat durationByVelocity = 0;
        CGFloat durationByDistance = 0;
        
        if(lastGesturePosition >= originalGesturePosition)
        {
            //moving to the right so complete
            newFrameXOrigin = 0;
            durationByVelocity = (self.lastContractionSlideOut.bounds.size.width - [self.lastContractionSlideOut rightBorderXValue]) / velocity.x;
            durationByDistance = ((self.lastContractionSlideOut.bounds.size.width - [self.lastContractionSlideOut rightBorderXValue]) / self.lastContractionSlideOut.bounds.size.width) * 0.3;
        }
        else
        {
            //moving to the left
            newFrameXOrigin = kSliderThumbShownXCoordinate;
            durationByVelocity = [self.lastContractionSlideOut rightBorderXValue] / velocity.x;
            durationByDistance = [self.lastContractionSlideOut rightBorderXValue] / self.lastContractionSlideOut.bounds.size.width * 0.3;
        }
        
        [UIView animateWithDuration:MIN(durationByDistance, durationByVelocity) animations:^{
            [self.lastContractionSlideOut setFrameXOrigin:newFrameXOrigin];
        }];
    }
}

- (void)lastContractionSwiped:(UISwipeGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.lastContractionSlideOut setFrameXOrigin:kSliderThumbShownXCoordinate];
    }];
}

#pragma mark -
#pragma mark Last Contraction Editing

- (void)contractionDeletedNotification:(NSNotification *)note
{
    [self updateLastContractionView];
    [self.averagesController updateAverages];
}


- (IBAction)deleteLastContraction:(id)sender
{
    //the history controller will trigger a notification for us to do our view updates
    [self.historyController deleteLastContraction];
    [self toggleLastContractionSliderState:YES];
    
    if(0 == [BCContraction countOfEntities])
    {
        //hide the last contraction thumb if we don't have any contractions now
        [UIView animateWithDuration:0.3 animations:^{
            [self.lastContractionSlideOut setFrameXOrigin:kSliderHiddenXCoordinate];
        }];
    }
}

- (IBAction)lastContractionIntensityPressed:(UIButton *)sender
{
    BCContraction *lastContraction = [BCContraction lastContraction];
    lastContraction.intensity = @([sender titleForState:UIControlStateNormal].intValue);
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
    [self updateLastContractionView];
    [self toggleLastContractionSliderState:YES];
    [self.historyController refreshData];
    [self.averagesController updateAverages];
}

#pragma mark -
#pragma mark Timer Updates

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
    if(nil == self.activeContraction)
    {
        self.secondsUntilNextContraction -= 1;
    }
    else
    {
        self.secondsIntoContraction += 1;
    }
    
    
    [self updateTimerLabel];
}

- (IBAction)startStopContraction:(id)sender
{
    [self clearTimer];
    self.secondsIntoContraction = 0;
    self.secondTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(secondTimerIncremented:) userInfo:nil repeats:YES];
    
    if(nil == self.activeContraction)
    {
        //there is no active contraction so they were in rest
        //so start one
        self.activeContraction = [BCContraction createEntity];
        self.activeContraction.startTime = [NSDate date];
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
        [self.startStopButton setImage:[UIImage imageNamed:@"stop-button"] forState:UIControlStateNormal];
        self.timerBackgroundView.backgroundColor = [[UIColor colorWithHexString:kMidOrangeColor] colorWithAlphaComponent:.15];
        
        self.timerLabel.text = @"00:00";
        
        //hide the last contraction area and show a motivational quote
        [UIView animateWithDuration:0.3 animations:^{
            self.lastContractionContainerView.alpha = 0.0;
            self.inspirationalLabel.alpha = 1.0;
            self.nextContractionEstimateLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.lastContractionSlideOut setFrameXOrigin:kSliderThumbShownXCoordinate];
        }];
        
    }
    else
    {
        //there was an active contraction so stop it
        self.activeContraction.endTime = [NSDate date];
        self.secondsUntilNextContraction = [BCContraction estimatedTimeUntilNextContraction];
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
        
        //post the adding of the contraction in case someone is interested
        [[NSNotificationCenter defaultCenter] postNotificationName:kFinishedContractionAddedNotification object:self userInfo:@{@"contraction" : self.activeContraction}];
        
        self.activeContraction = nil;
        [self.startStopButton setImage:[UIImage imageNamed:@"start-button"] forState:UIControlStateNormal];
        self.timerBackgroundView.backgroundColor = [[UIColor colorWithHexString:kDarkGreenColor] colorWithAlphaComponent:.1];
        self.timerLabel.text = @"";
        [self updateLastContractionView];
        
        //show the last contraction area and hide the motivational quote
        [UIView animateWithDuration:0.2 animations:^{
            self.lastContractionContainerView.alpha = 1.0;
            self.inspirationalLabel.alpha = 0.0;
            self.nextContractionEstimateLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            //show the contraction slider so they can set intensity
            [UIView animateWithDuration:0.3 animations:^{
                [self.lastContractionSlideOut setFrameXOrigin:kSliderShownXCoordinate];
            }];
        }];
    }
    
    [self updateViewState];
}

#pragma mark -
#pragma mark Segue handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"LastContractionEdit"])
    {
        BCContractionEditViewController *editController = segue.destinationViewController;
        editController.delegate = self;
    }
}

#pragma mark -
#pragma mark BCContractionEditViewControllerDelegate

- (void)contractionEditViewController:(BCContractionEditViewController *)controller didFinishWithSave:(BOOL)saved
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
