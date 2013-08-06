//
//  BCAudioAlertEditViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 8/4/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCAudioAlertEditViewController.h"
#import "BCAudioReminder.h"


@interface BCAudioAlertEditViewController ()

@property (nonatomic, strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

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
    self.player.delegate = self;
    [self.player prepareToPlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playStop:(id)sender
{
    if([self.player isPlaying])
    {
        [self.player pause];
        [self.player setCurrentTime:0];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    else
    {
        [self.player play];
        [self.playButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark AudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

@end
