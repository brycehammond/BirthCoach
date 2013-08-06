//
//  BCAudioAlertEditViewController.h
//  BirthCoach
//
//  Created by Bryce Hammond on 8/4/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCSettingsBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@class BCAudioReminder;

@interface BCAudioAlertEditViewController : BCSettingsBaseViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property (nonatomic, strong) BCAudioReminder *reminder;

@end
