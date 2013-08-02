//
//  BCStretchableButton.m
//  BirthCoach
//
//  Created by Bryce Hammond on 8/2/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCStretchableButton.h"

@implementation BCStretchableButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setupView
{
    UIImage *backgroundImage = [self backgroundImageForState:UIControlStateNormal];
    [self setBackgroundImage:[backgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    
    backgroundImage = [self backgroundImageForState:UIControlStateHighlighted];
    [self setBackgroundImage:[backgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    
    backgroundImage = [self backgroundImageForState:UIControlStateSelected];
    [self setBackgroundImage:[backgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateSelected];
}


@end
