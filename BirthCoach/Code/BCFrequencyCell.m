//
//  BCFrequencyCell.m
//  BirthCoach
//
//  Created by Bryce Hammond on 7/5/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCFrequencyCell.h"

@interface BCFrequencyCell ()

@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;

@end

@implementation BCFrequencyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupCell];
}

- (void)setupCell
{
    self.frequencyLabel.font = [UIFont fontWithName:@"OpenSans" size:self.frequencyLabel.font.pointSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrequency:(NSNumber *)frequency
{
    self.frequencyLabel.text = [BCTimeIntervalFormatter timeStringForInterval:frequency.floatValue];
}

@end
