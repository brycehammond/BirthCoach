//
//  BCAudioAlertEditViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 8/4/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCAudioAlertEditViewController.h"
#import "BCAudioReminder.h"
#import <AVFoundation/AVFoundation.h>

@interface BCAudioAlertEditViewController ()

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation BCAudioAlertEditViewController

@synthesize reminder = _reminder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.player = [[AVAudioPlayer alloc] initWithData:self.reminder.audioData error:nil];
    [self.player prepareToPlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
