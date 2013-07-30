//
//  BCSettingsViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 7/30/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCSettingsViewController.h"

@interface BCSettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *displayOnSwitch;

@end

@implementation BCSettingsViewController

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
    self.displayOnSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kDisplayKeepOnKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender
{
    [self.delegate settingsControllerDidDismiss:self];
}

- (IBAction)clearContractions:(id)sender
{
    [BCContraction truncateAll];
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:nil];
}

- (IBAction)displayOnChanged:(UISwitch *)sender
{
    BOOL displayOn = sender.on;
    [[NSUserDefaults standardUserDefaults] setBool:displayOn forKey:kDisplayKeepOnKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[UIApplication sharedApplication] setIdleTimerDisabled:displayOn];
}

@end
