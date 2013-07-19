//
//  BCContractionEditViewController.h
//  BirthCoach
//
//  Created by Bryce Hammond on 7/18/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCBaseViewController.h"

@class BCContractionEditViewController;
@class BCContraction;

@protocol BCContractionEditViewControllerDelegate <NSObject>

- (void)contractionEditViewController:(BCContractionEditViewController *)controller didFinishWithSave:(BOOL)saved;

@end

@interface BCContractionEditViewController : BCBaseViewController

@property (nonatomic, weak) id<BCContractionEditViewControllerDelegate> delegate;
@property (nonatomic, strong) BCContraction *contraction;

@end
