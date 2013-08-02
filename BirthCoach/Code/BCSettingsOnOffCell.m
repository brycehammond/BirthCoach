//
//  BCSettingsOnOffCell.m
//  BirthCoach
//
//  Created by Bryce Hammond on 8/1/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCSettingsOnOffCell.h"

@implementation BCSettingsOnOffCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupCell
{
    [super setupCell];
    [self.onOffSwitch addTarget:self action:@selector(onOffSwitchChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)onOffSwitchChanged:(UISwitch *)sender
{
    [self.delegate settingsOnOffCell:self didSwitchOn:self.onOffSwitch.on];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //don't do anything and leave it be
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    //don't do anything and leave it be
}

@end
