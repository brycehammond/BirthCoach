//
//  BCContractionEditViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 7/18/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCContractionEditViewController.h"
#import "BCTimeIntervalFormatter.h"

@interface BCContractionEditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *startTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSDate *startTime;

@end

@implementation BCContractionEditViewController

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
	self.startTime = self.contraction.startTime;
    self.duration = self.contraction.duration;
    
    self.startTimeTitleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:self.startTimeTitleLabel.font.pointSize];
    self.durationTitleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:self.durationTitleLabel.font.pointSize];
    
    self.startTimeLabel.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:self.startTimeLabel.font.pointSize];
    self.durationLabel.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:self.durationLabel.font.pointSize];
    [self updateView];
}

- (void)updateView
{
    NSDateFormatter *startTimeFormatter = [[NSDateFormatter alloc] init];
    startTimeFormatter.dateFormat = @"HH:mm a";
    self.durationLabel.text = [[BCTimeIntervalFormatter timeStringForInterval:self.duration] stringByAppendingString:@"  "];
    self.startTimeLabel.text = [[startTimeFormatter stringFromDate:self.startTime] stringByAppendingString:@"  "];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Button Handling

- (IBAction)cancelPressed:(id)sender
{
    [self.delegate contractionEditViewController:self didFinishWithSave:NO];
}

- (IBAction)savePressed:(id)sender
{
    [self.delegate contractionEditViewController:self didFinishWithSave:YES];
}

@end
