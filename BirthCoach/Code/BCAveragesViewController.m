//
//  BCAveragesViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 6/29/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCAveragesViewController.h"
#import "UIScrollView+CurrentPage.h"
#import "BCPageControl.h"

@interface BCAveragesViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *averagesScrollView;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet BCPageControl *pageControl;

//15 Minute
@property (weak, nonatomic) IBOutlet UILabel *fifteenMinuteDuration;
@property (weak, nonatomic) IBOutlet UILabel *fifteenMinuteIntensity;
@property (weak, nonatomic) IBOutlet UILabel *fifteenMinuteFrequency;

//30 Minute
@property (weak, nonatomic) IBOutlet UILabel *thirtyMinuteDuration;
@property (weak, nonatomic) IBOutlet UILabel *thirtyMinuteIntensity;
@property (weak, nonatomic) IBOutlet UILabel *thirtyMinuteFrequency;

//1 Hour
@property (weak, nonatomic) IBOutlet UILabel *oneHourDuration;
@property (weak, nonatomic) IBOutlet UILabel *oneHourIntensity;
@property (weak, nonatomic) IBOutlet UILabel *oneHourFrequency;

//minute average scroller
@property (weak, nonatomic) IBOutlet UIScrollView *minuteNumberScrollView;
@property (weak, nonatomic) IBOutlet UILabel *fifteenMinuteNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirtyMinuteNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixtyMinuteNumberLabel;

@property (nonatomic, strong) NSArray *dataLabels;
@property (nonatomic, strong) NSTimer *updateTimer;

@end

@implementation BCAveragesViewController

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
	self.averagesScrollView.contentSize = CGSizeMake(self.averagesScrollView.frame.size.width * 3, self.averagesScrollView.frame.size.height);
    self.averageLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:self.averageLabel.font.pointSize];
    self.dataLabels = @[self.fifteenMinuteDuration, self.fifteenMinuteIntensity, self.fifteenMinuteFrequency,
                        self.thirtyMinuteDuration, self.thirtyMinuteIntensity, self.thirtyMinuteFrequency,
                        self.oneHourDuration, self.oneHourIntensity, self.oneHourFrequency];
    
    for(UILabel *dataLabel in self.dataLabels)
    {
        dataLabel.font = [UIFont fontWithName:@"OpenSans" size:dataLabel.font.pointSize];
    }
    
    for(UIView *subview in self.averagesScrollView.subviews)
    {
        if([subview isKindOfClass:[UILabel class]] && NO == [self.dataLabels containsObject:subview])
        {
            UILabel *titleLabel = (UILabel *)subview;
            titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:titleLabel.font.pointSize];
        }
    }
    
    self.minuteNumberScrollView.contentSize = CGSizeMake(self.minuteNumberScrollView.frame.size.width * 3, self.minuteNumberScrollView.frame.size.height);
    
    self.thirtyMinuteNumberLabel.alpha = 0;
    self.sixtyMinuteNumberLabel.alpha = 0;
    
    self.fifteenMinuteNumberLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:self.fifteenMinuteNumberLabel.font.pointSize];
    self.thirtyMinuteNumberLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:self.thirtyMinuteNumberLabel.font.pointSize];
    self.sixtyMinuteNumberLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:self.sixtyMinuteNumberLabel.font.pointSize];
    
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 1;
    self.pageControl.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateAverages];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contractionAdded:) name:kFinishedContractionAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contractionUpdated:) name:kContractionEditedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appForegroundNotification:) name:kForegroundingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBackgroundNotification:) name:kBackgroundingNotification object:nil];
    
    
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopTimer];
}

#pragma mark -
#pragma mark Update Timer

- (void)startTimer
{
    //have averages timer update the display every minute
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updateAveragesFromTimer:) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    if([self.updateTimer isValid])
    {
        [self.updateTimer invalidate];
    }
    self.updateTimer = nil;
}

#pragma mark -
#pragma mark Notification and Timer handling

- (void)appForegroundNotification:(NSNotification *)note
{
    [self startTimer];
    [self updateAverages];
}

- (void)appBackgroundNotification:(NSNotification *)note
{
    [self stopTimer];
}

- (void)contractionAdded:(NSNotification *)note
{
    [self updateAverages];
}

- (void)contractionUpdated:(NSNotification *)note
{
    [self updateAverages];
    
}

- (void)updateAveragesFromTimer:(NSTimer *)timer
{
    [self updateAverages];
}


#pragma mark -
#pragma mark Display Updatese

- (void)updateAverages
{
    self.fifteenMinuteDuration.text = [BCTimeIntervalFormatter timeStringForInterval:[BCContraction averageDurationForLastMinutes:15]];
    self.fifteenMinuteFrequency.text = [BCTimeIntervalFormatter timeStringForInterval:[BCContraction averageFrequencyForLastMinutes:15]];
    self.fifteenMinuteIntensity.text =  [NSString stringWithFormat:@"%0.1f", [BCContraction averageIntensityForLastMinutes:15].floatValue];
    
    self.thirtyMinuteDuration.text = [BCTimeIntervalFormatter timeStringForInterval:[BCContraction averageDurationForLastMinutes:30]];
    self.thirtyMinuteFrequency.text = [BCTimeIntervalFormatter timeStringForInterval:[BCContraction averageFrequencyForLastMinutes:30]];
    self.thirtyMinuteIntensity.text =  [NSString stringWithFormat:@"%0.1f", [BCContraction averageIntensityForLastMinutes:30].floatValue];
    
    self.oneHourDuration.text = [BCTimeIntervalFormatter timeStringForInterval:[BCContraction averageDurationForLastMinutes:60]];
    self.oneHourFrequency.text = [BCTimeIntervalFormatter timeStringForInterval:[BCContraction averageFrequencyForLastMinutes:60]];
    self.oneHourIntensity.text =  [NSString stringWithFormat:@"%0.1f", [BCContraction averageIntensityForLastMinutes:60].floatValue];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat numberScrollerWidth = self.minuteNumberScrollView.frame.size.width;
    
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat offsetFactor = contentOffset.x / scrollView.contentSize.width;
    CGFloat minuteNumberOffset = floor(offsetFactor * self.minuteNumberScrollView.contentSize.width);
    self.minuteNumberScrollView.contentOffset = CGPointMake(minuteNumberOffset, 0);
    
    self.fifteenMinuteNumberLabel.alpha = 1 - MAX(minuteNumberOffset / numberScrollerWidth, 0);
    
    if(minuteNumberOffset > numberScrollerWidth)
    {
        self.thirtyMinuteNumberLabel.alpha = 1 - MAX((minuteNumberOffset - numberScrollerWidth) / numberScrollerWidth, 0);
    }
    else
    {
        self.thirtyMinuteNumberLabel.alpha = MAX(minuteNumberOffset / numberScrollerWidth, 0);
    }
    
    if(minuteNumberOffset > 2 * numberScrollerWidth)
    {
        self.sixtyMinuteNumberLabel.alpha = 1 - MAX((minuteNumberOffset - 2 * numberScrollerWidth) / numberScrollerWidth, 0);
    }
    else
    {
        self.sixtyMinuteNumberLabel.alpha = MAX((minuteNumberOffset - numberScrollerWidth) / numberScrollerWidth, 0);
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.currentPage;
}

#pragma mark -
#pragma BCPageControlDelegate methods

- (void)pageControl:(BCPageControl *)pageControl didSelectPage:(NSInteger)page
{
    self.averagesScrollView.currentPage = page;
}

@end
