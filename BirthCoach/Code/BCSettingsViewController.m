//
//  BCSettingsViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 7/30/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCSettingsViewController.h"
#import "BCSettingsTitleCell.h"
#import "BCMotivationalListViewController.h"
#import "BCAudioAlertsViewController.h"

@interface BCSettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

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
    self.settingsTableView.backgroundColor = [UIColor colorWithHexString:kLightOrangeColor];
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
    
    if(0 == indexPath.row)
    {
        //Go to motivational controller
        BCMotivationalListViewController *motivationController = [[UIStoryboard settingsStoryboard] instantiateViewControllerWithIdentifier:@"MotivationList"];
        [self.navigationController pushViewController:motivationController animated:YES];
    }
    else if(1 == indexPath.row)
    {
        //Go to audio settings
        BCAudioAlertsViewController *audioAlertsController = [[UIStoryboard settingsStoryboard] instantiateViewControllerWithIdentifier:@"AudioAlerts"];
        [self.navigationController pushViewController:audioAlertsController animated:YES];
    }
    else if(2 == indexPath.row)
    {
        //Clear all contractions
        
        [[[UIAlertView alloc] initWithTitle:@"Clear Contractions" message:@"This will clear your entire contraction history.  Are you sure you want to continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Clear", nil] show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Clear"])
    {
        [BCContraction truncateAll];
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:nil];
    }
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
