//
//  BCAudioReminderPlayer.m
//  BirthCoach
//
//  Created by Bryce Hammond on 8/4/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCAudioReminderPlayer.h"
#import "BCAudioReminder.h"

@interface BCAudioReminderPlayer ()

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation BCAudioReminderPlayer

@synthesize reminder = _reminder;

- (void)setReminder:(BCAudioReminder *)reminder
{
    _reminder = reminder;
    [self.player stop];
    self.player = [[AVAudioPlayer alloc] initWithData:reminder.audioData error:nil];
    [self.player prepareToPlay];

}

- (void)play
{
    [self.player play];
}

- (void)stop
{
    [self.player stop];
}

- (BOOL)isPlaying
{
    return self.player.isPlaying;
}

@end
