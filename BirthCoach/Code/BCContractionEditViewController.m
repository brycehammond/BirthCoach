//
//  BCContractionEditViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 7/18/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCContractionEditViewController.h"

@interface BCContractionEditViewController ()

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
	// Do any additional setup after loading the view.
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
