//
//  BCSettingsTitleCell.m
//  BirthCoach
//
//  Created by Bryce Hammond on 8/1/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCSettingsTitleCell.h"

@interface BCSettingsTitleCell ()

@property (nonatomic, weak) IBOutlet UIImageView *disclosureImageView;
@property (nonatomic, weak) IBOutlet UIView *lowerBorder;

@end

@implementation BCSettingsTitleCell

@synthesize disclosureIndicatorHidden = _disclosureIndicatorHidden;

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
    self.backgroundColor = [UIColor colorWithHexString:kLightOrangeColor];
    self.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:self.titleLabel.font.pointSize];
    
    if(self.lowerBorder)
    {
        //move the lower border to the cell itself
        [self addSubview:self.lowerBorder];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.backgroundColor = [UIColor colorWithHexString:selected ? kMidOrangeColor : kLightOrangeColor];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.backgroundColor = [UIColor colorWithHexString:highlighted ? kMidOrangeColor : kLightOrangeColor];
}

- (void)setDisclosureIndicatorHidden:(BOOL)disclosureIndicatorHidden
{
    _disclosureIndicatorHidden = disclosureIndicatorHidden;
    self.disclosureImageView.hidden = disclosureIndicatorHidden;
}

@end
