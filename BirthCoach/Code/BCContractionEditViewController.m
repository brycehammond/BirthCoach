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
@property (weak, nonatomic) IBOutlet UIPickerView *durationPickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePickerView;
@property (nonatomic, strong) IBOutlet UIView *fadeView;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSDate *startTime;

@end

@implementation BCContractionEditViewController

@synthesize fadeView = _fadeView;

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
    
    //Add tap gestures to bring up editing controls
    UITapGestureRecognizer *startTimeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTimeTapped:)];
    [self.startTimeLabel addGestureRecognizer:startTimeGesture];
    
    UITapGestureRecognizer *durationGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(durationTapped:)];
    [self.durationLabel addGestureRecognizer:durationGesture];
    
    UITapGestureRecognizer *fadeViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeViewTapped:)];
    [self.fadeView addGestureRecognizer:fadeViewGesture];
    
    self.fadeView.alpha = 0.0;
    
    [self.durationPickerView setFrameYOrigin:self.view.frame.size.height];
    [self.startTimePickerView setFrameYOrigin:self.view.frame.size.height];
    
    
    [self updateView];
}

- (void)updateView
{
    NSDateFormatter *startTimeFormatter = [[NSDateFormatter alloc] init];
    startTimeFormatter.timeStyle = NSDateFormatterShortStyle;
    startTimeFormatter.dateStyle = NSDateFormatterNoStyle;
    
    self.durationLabel.text = [[BCTimeIntervalFormatter timeStringForInterval:self.duration] stringByAppendingString:@"  "];
    self.startTimeLabel.text = [[startTimeFormatter stringFromDate:self.startTime] stringByAppendingString:@"  "];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Gesture Handling

- (void)startTimeTapped:(UIGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.startTimePickerView setFrameYOrigin:self.view.frame.size.height - self.startTimePickerView.frame.size.height];
        self.fadeView.alpha = 0.3;
    }];
}

- (void)durationTapped:(UIGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.durationPickerView setFrameYOrigin:self.view.frame.size.height - self.durationPickerView.frame.size.height];
        self.fadeView.alpha = 0.3;
    }];
}

- (void)fadeViewTapped:(UIGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.durationPickerView setFrameYOrigin:self.view.frame.size.height];
        [self.startTimePickerView setFrameYOrigin:self.view.frame.size.height];
        self.fadeView.alpha = 0.0;
    }];
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

#pragma mark -
#pragma mark UIPickerView Delegate/DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

@end
