//
//  BCHistoryViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 6/30/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCHistoryViewController.h"

@interface BCHistoryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contractionHistoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *intensityHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequencyHeaderLabel;

@end

@implementation BCHistoryViewController

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
	self.contractionHistoryLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:self.contractionHistoryLabel.font.pointSize];
    
    for(UILabel *headerLabel in @[self.durationHeaderLabel, self.intensityHeaderLabel, self.frequencyHeaderLabel])
    {
        headerLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:headerLabel.font.pointSize];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
