//
//  BCPageControl.h
//  BirthCoach
//
//  Created by Bryce Hammond on 6/29/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCPageControl;

@protocol BCPageControlDelegate <NSObject>

- (void)pageControl:(BCPageControl *)pageControl didSelectPage:(NSInteger)page;

@end

@interface BCPageControl : UIPageControl
{
    NSInteger currentPage;
}

@property (nonatomic, weak) id<BCPageControlDelegate> delegate;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) BOOL hidesForSinglePage;
@property (nonatomic, assign) float dotSize;
@property (nonatomic, assign) float dotSpacing;

@end
