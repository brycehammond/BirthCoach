//
//  UIScrollView+CurrentPage.m
//  BirthCoach
//
//  Created by Bryce Hammond on 6/29/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "UIScrollView+CurrentPage.h"

@implementation UIScrollView (CurrentPage)

- (NSInteger)currentPage
{
    return (NSInteger)floor(self.contentOffset.x / self.bounds.size.width) + 1;
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [self setContentOffset:CGPointMake((currentPage - 1) * self.bounds.size.width, 0) animated:YES];
}

@end
