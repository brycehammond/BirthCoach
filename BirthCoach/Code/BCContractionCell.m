//
//  BCContractionCell.m
//  BirthCoach
//
//  Created by Bryce Hammond on 7/5/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCContractionCell.h"
#import "BCContraction+Convenience.h"

@interface BCContractionCell ()
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *intensityLabel;

@end

@implementation BCContractionCell

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
    self.durationLabel.font = [UIFont fontWithName:@"OpenSans" size:self.durationLabel.font.pointSize];
    self.intensityLabel.font = [UIFont fontWithName:@"OpenSans" size:self.intensityLabel.font.pointSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContraction:(BCContraction *)contraction
{
    self.durationLabel.text = [BCTimeIntervalFormatter timeStringForInterval:contraction.duration];
    self.intensityLabel.text = contraction.intensity.integerValue > 0 ? contraction.intensity.stringValue : @"-";
}

@end
