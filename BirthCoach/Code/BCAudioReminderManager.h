//
//  BCAudioReminderManager.h
//  BirthCoach
//
//  Created by Bryce Hammond on 8/4/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCAudioReminderManager : NSObject

+ (BCAudioReminderManager *)sharedManager;

- (void)scheduleAllReminders;
- (void)cancelReminders;

@end
