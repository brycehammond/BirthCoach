//
//  BCAudioReminderPlayer.h
//  BirthCoach
//
//  Created by Bryce Hammond on 8/4/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class BCAudioReminder;

@interface BCAudioReminderPlayer : NSObject

@property (nonatomic, strong) BCAudioReminder *reminder;

- (void)play;
- (void)stop;
- (BOOL)isPlaying;

@end
