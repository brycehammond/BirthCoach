//
//  BCAudioAlertsViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 8/3/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCAudioAlertsViewController.h"
#import "BCSettingsTitleCell.h"

@interface BCAudioAlertsViewController ()

@end

@implementation BCAudioAlertsViewController

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

#pragma mark UITableViewDelegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        BCSettingsOnOffCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnOffCell"];
        cell.titleLabel.text = @"Audio Reminders Enabled";
        cell.onOffSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kAudioRemindersOnKey];
        cell.delegate = self;
        return cell;
    }
    else
    {
        BCSettingsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark BCSettingsOnOffCellDelegate

- (void)settingsOnOffCell:(BCSettingsOnOffCell *)cell didSwitchOn:(BOOL)switchOn
{
    [[NSUserDefaults standardUserDefaults] setBool:switchOn forKey:kAudioRemindersOnKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
