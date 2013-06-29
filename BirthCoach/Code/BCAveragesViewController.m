//
//  BCAveragesViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 6/29/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCAveragesViewController.h"

@interface BCAveragesViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *averagesScrollView;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;


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
            titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:titleLabel.font.pointSize];
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateAverages];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contractionAdded:) name:kFinishedContractionAddedNotification object:nil];
    
    //have averages timer update the display every minute
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updateAveragesFromTimer:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if([self.updateTimer isValid])
    {
        [self.updateTimer invalidate];
    }
    self.updateTimer = nil;
}

- (void)contractionAdded:(NSNotification *)note
{
    [self updateAverages];
}

- (void)updateAveragesFromTimer:(NSTimer *)timer
{
    [self updateAverages];
}

- (void)updateAverages
{
    self.fifteenMinuteDuration.text = [BCTimeIntervalFormatter timeStringForInterval:[BCContraction averageDurationForLastMinutes:15]];
    self.fifteenMinuteFrequency.text = [BCTimeIntervalFormatter timeStringForInterval:[BCContraction averageFrequencyForLastMinutes:15]];
    
    self.thirtyMinuteDuration.text = [BCTimeIntervalFormatter timeStringForInterval:[BCContraction averageDurationForLastMinutes:30]];
    self.thirtyMinuteFrequency.text = [BCTimeIntervalFormatter timeStringForInterval:[BCContraction averageFrequencyForLastMinutes:30]];
    
    self.oneHourDuration.text = [BCTimeIntervalFormatter timeStringForInterval:[BCContraction averageDurationForLastMinutes:60]];
    self.oneHourFrequency.text = [BCTimeIntervalFormatter timeStringForInterval:[BCContraction averageFrequencyForLastMinutes:60]];
}

@end
