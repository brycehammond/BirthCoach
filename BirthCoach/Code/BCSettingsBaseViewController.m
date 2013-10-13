//
//  BCSettingsBaseViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 8/2/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCSettingsBaseViewController.h"

@interface BCSettingsBaseViewController ()

@end

@implementation BCSettingsBaseViewController

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
    self.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:self.titleLabel.font.pointSize];
	self.view.backgroundColor = [UIColor colorWithHexString:kLightOrangeColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
