//
//  BCSettingsViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 7/30/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCSettingsViewController.h"
#import "BCSettingsTitleCell.h"

@interface BCSettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

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
    self.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:self.titleLabel.font.pointSize];
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


#pragma mark -
#pragma mark UITableViewDatasource/Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BCSettingsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
    if(0 == indexPath.row)
    {
        cell.titleLabel.text = @"Motivation";
        cell.disclosureIndicatorHidden = NO;
    }
    else if(1 == indexPath.row)
    {
        cell.titleLabel.text = @"Audio Reminders";
        cell.disclosureIndicatorHidden = NO;
    }
    else if(2 == indexPath.row)
    {
        cell.titleLabel.text = @"Clear Contractions";
        cell.disclosureIndicatorHidden = YES;
    }
    else if(3 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"OnOffCell"];
        cell.titleLabel.text = @"Disable Auto-Lock";
        BCSettingsOnOffCell *onOffCell = (BCSettingsOnOffCell *)cell;
        onOffCell.delegate = self;
        onOffCell.onOffSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kDisplayKeepOnKey];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark BCSettingsOnOffCellDelegate

- (void)settingsOnOffCell:(BCSettingsOnOffCell *)cell didSwitchOn:(BOOL)switchOn
{
    [[NSUserDefaults standardUserDefaults] setBool:switchOn forKey:kDisplayKeepOnKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[UIApplication sharedApplication] setIdleTimerDisabled:switchOn];
}

@end
