//
//  BCHistoryViewController.h
//  BirthCoach
//
//  Created by Bryce Hammond on 6/30/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCContractionEditViewController.h"

#define kHistoryViewTopBound 162
#define kHistoryViewBottomBound 368

@interface BCHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, BCContractionEditViewControllerDelegate>

- (void)refreshData;
- (void)deleteLastContraction;
- (void)hideSlider;
- (void)moveToBottomBound;
- (void)moveToTopBound;

@end
