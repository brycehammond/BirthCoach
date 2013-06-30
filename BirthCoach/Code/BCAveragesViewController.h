//
//  BCAveragesViewController.h
//  BirthCoach
//
//  Created by Bryce Hammond on 6/29/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPageControl.h"

@interface BCAveragesViewController : UIViewController <UIScrollViewDelegate, BCPageControlDelegate>

- (void)updateAverages;

@end
