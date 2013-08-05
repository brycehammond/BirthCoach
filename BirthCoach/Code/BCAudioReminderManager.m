//
//  BCAudioReminderManager.m
//  BirthCoach
//
//  Created by Bryce Hammond on 8/4/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCAudioReminderManager.h"
#import "BCAudioReminderPlayer.h"
#import "BCAudioReminder.h"

@interface BCAudioReminderManager ()

@property (nonatomic, strong) NSMutableArray *timers;
@property (nonatomic, strong) NSMutableArray *players;

@end

@implementation BCAudioReminderManager


+ (BCAudioReminderManager *)sharedManager
{
    static dispatch_once_t pred;
    static BCAudioReminderManager *singleton = nil;
    
    dispatch_once(&pred,
                  ^{
                      singleton = [[self alloc] init];
                  });
    return singleton;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.timers = [[NSMutableArray alloc] init];
        self.players = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)scheduleAllReminders
{
    [self cancelReminders];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:kAudioRemindersOnKey])
    {    
        BCContraction *activeContraction = [BCContraction activeContraction];
        
        if(nil != activeContraction)
        {
            NSTimeInterval timeSinceStartOfContraction = [[NSDate date] timeIntervalSinceDate:activeContraction.startTime];
            NSArray *reminders = [BCAudioReminder findAllSortedBy:@"seconds" ascending:YES];
            for(BCAudioReminder *reminder in reminders)
            {
                if(reminder.seconds.intValue > timeSinceStartOfContraction)
                {
                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:reminder.seconds.intValue - timeSinceStartOfContraction target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
                    [self.timers addObject:timer];
                    BCAudioReminderPlayer *player = [[BCAudioReminderPlayer alloc] init];
                    player.reminder = reminder;
                    [self.players addObject:player];
                }
            }
        }
    }
}

- (void)timerFired:(NSTimer *)timer
{
    NSUInteger timerIdx = [self.timers indexOfObject:timer];
    if(NSNotFound != timerIdx)
    {
        BCAudioReminderPlayer *player = self.players[timerIdx];
        [player play];
    }
}

- (void)cancelReminders
{
    for(NSTimer *timer in self.timers)
    {
        if([timer isValid])
            [timer invalidate];
    }
    
    for(BCAudioReminderPlayer *player in self.players)
    {
        if(player.isPlaying)
            [player stop];
    }
    
    [self.timers removeAllObjects];
    [self.players removeAllObjects];
}

@end
