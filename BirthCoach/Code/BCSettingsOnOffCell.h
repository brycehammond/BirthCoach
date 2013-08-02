//
//  BCSettingsOnOffCell.h
//  BirthCoach
//
//  Created by Bryce Hammond on 8/1/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCSettingsTitleCell.h"

@class BCSettingsOnOffCell;

@protocol BCSettingsOnOffCellDelegate <NSObject>

- (void)settingsOnOffCell:(BCSettingsOnOffCell *)cell didSwitchOn:(BOOL)switchOn;

@end

@interface BCSettingsOnOffCell : BCSettingsTitleCell

@property (nonatomic, weak) IBOutlet UISwitch *onOffSwitch;
@property (nonatomic, weak) id<BCSettingsOnOffCellDelegate> delegate;

@end
