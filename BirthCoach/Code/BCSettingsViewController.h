//
//  BCSettingsViewController.h
//  BirthCoach
//
//  Created by Bryce Hammond on 7/30/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCBaseViewController.h"
#import "BCSettingsOnOffCell.h"

@class BCSettingsViewController;

@protocol BCSettingsViewControllerDelegate <NSObject>

- (void)settingsControllerDidDismiss:(BCSettingsViewController *)controller;

@end

@interface BCSettingsViewController : BCBaseViewController <UITableViewDataSource, UITableViewDelegate, BCSettingsOnOffCellDelegate>

@property (nonatomic, weak) id<BCSettingsViewControllerDelegate> delegate;

@end
