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

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *doneBannerView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) NSDate *startTime;


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
    
    self.doneBannerView.frameYOrigin = self.view.frameHeight;
    self.durationPickerView.frameYOrigin = self.doneBannerView.bottomBorderYValue;
    self.startTimePickerView.frameYOrigin = self.doneBannerView.bottomBorderYValue;
    
    [self.startTimePickerView addTarget:self action:@selector(startTimeChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self updateView];
    
    //Set up the picker view current state and contraints
    [self.durationPickerView selectRow:MIN((NSInteger)self.duration / 60, 60) inComponent:0 animated:NO];
    [self.durationPickerView selectRow:(NSInteger)self.duration % 60 inComponent:1 animated:NO];
    self.startTimePickerView.date = self.startTime;
    
    self.startTimePickerView.minimumDate = [self.contraction previousContraction].endTime;
    self.startTimePickerView.maximumDate = [self.contraction nextContraction].startTime;
    
    self.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:self.titleLabel.font.pointSize];
    self.saveButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:self.saveButton.titleLabel.font.pointSize];
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:self.cancelButton.titleLabel.font.pointSize];
    self.doneButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:self.doneButton.titleLabel.font.pointSize];
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
        self.startTimePickerView.frameYOrigin = self.view.frameHeight - self.startTimePickerView.frameHeight;
        self.doneBannerView.frameYOrigin = self.startTimePickerView.frameYOrigin - self.doneBannerView.frameHeight;
        self.fadeView.alpha = 0.3;
    }];
}

- (void)durationTapped:(UIGestureRecognizer *)gesture
{
    [self.durationPickerView reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        self.durationPickerView.frameYOrigin = self.view.frameHeight - self.durationPickerView.frameHeight;
        self.doneBannerView.frameYOrigin = self.durationPickerView.frameYOrigin - self.doneBannerView.frameHeight;
        self.fadeView.alpha = 0.3;
    }];
}

- (void)fadeViewTapped:(UIGestureRecognizer *)gesture
{
    [self hideAllPickers];
}

#pragma mark -
#pragma mark Picker animation

- (void)hideAllPickers
{
    [UIView animateWithDuration:0.3 animations:^{
        self.doneBannerView.frameYOrigin = self.view.frameHeight;
        self.durationPickerView.frameYOrigin = self.doneBannerView.bottomBorderYValue;
        self.startTimePickerView.frameYOrigin = self.doneBannerView.bottomBorderYValue;
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
    self.contraction.startTime = self.startTime;
    self.contraction.endTime = [self.startTime dateByAddingTimeInterval:self.duration];
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
    [self.delegate contractionEditViewController:self didFinishWithSave:YES];
}

- (IBAction)donePressed:(id)sender
{
    [self hideAllPickers];
}

#pragma mark -
#pragma mark Start Time Changing

- (void)startTimeChanged:(UIDatePicker *)datePicker
{
    self.startTime = datePicker.date;
    [self.durationPickerView reloadAllComponents];
    [self updateView];
}

#pragma mark -
#pragma mark UIPickerView Delegate/DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(1 == component)
    {
        return 60;
    }
    else
    {
        return [self maximumMinute] + 1;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *numberValue = [NSString stringWithFormat:@"%i",row];
    
    if(1 == numberValue.length)
    {
       //add a 0 to the front
        numberValue = [@"0" stringByAppendingString:numberValue];
    }

    return numberValue;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.duration = [pickerView selectedRowInComponent:0] * 60 + [pickerView selectedRowInComponent:1];
    [self updateView];
}

- (NSInteger)maximumMinute
{
    BCContraction *nextContraction = [self.contraction nextContraction];
    NSTimeInterval maxDuration = INT_MAX;
    
    if(nil != nextContraction)
    {
        maxDuration = [nextContraction.startTime timeIntervalSinceDate:self.startTime];
    }
    
    return  MIN(maxDuration / 60, 59);
}

@end
