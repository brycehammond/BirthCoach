//
//  BCAudioAlertsViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 8/3/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCAudioAlertsViewController.h"
#import "BCSettingsTitleCell.h"
#import "BCAudioReminderManager.h"
#import "BCAudioReminder.h"

@interface BCAudioAlertsViewController ()

@property (nonatomic, strong) NSMutableArray *reminders;
@property (strong, nonatomic) IBOutlet UIView *remindersTableView;

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
	self.remindersTableView.backgroundColor = [UIColor colorWithHexString:kLightOrangeColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.reminders = [BCAudioReminder findAllSortedBy:@"seconds" ascending:YES].mutableCopy;
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
        return self.reminders.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        BCSettingsOnOffCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnOffCell"];
        cell.titleLabel.text = @"Audio Reminders";
        cell.onOffSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kAudioRemindersOnKey];
        cell.delegate = self;
        return cell;
    }
    else
    {
        BCSettingsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ seconds", [[self.reminders[indexPath.row] seconds] stringValue]];
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
    
    if(switchOn)
    {
        [[BCAudioReminderManager sharedManager] scheduleAllReminders];
    }
    else
    {
        [[BCAudioReminderManager sharedManager] cancelReminders];
    }
}


@end
