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

    self.contentView.backgroundColor = selected ? [[UIColor colorWithHexString:kMidGreenColor] colorWithAlphaComponent:0.15] : [UIColor whiteColor];
}

- (void)setFrequency:(NSNumber *)frequency
{
    self.frequencyLabel.text = [BCTimeIntervalFormatter timeStringForInterval:frequency.floatValue];
}

@end
