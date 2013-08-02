//
//  BCSettingsTitleCell.h
//  BirthCoach
//
//  Created by Bryce Hammond on 8/1/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCSettingsTitleCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) BOOL disclosureIndicatorHidden;

- (void)setupCell;

@end
