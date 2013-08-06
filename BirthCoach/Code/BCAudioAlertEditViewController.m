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
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSData *currentAudioData;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation BCAudioAlertEditViewController

@synthesize reminder = _reminder;
@synthesize recorder = _recorder;

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
    self.currentAudioData = self.reminder.audioData;
	self.player = [[AVAudioPlayer alloc] initWithData:self.currentAudioData error:nil];
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

- (AVAudioRecorder *)recorder
{
    if(nil == _recorder)
    {
        NSString *recordFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"BirthCoach_reminder.m4a"];
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:recordFilePath] settings:@{AVNumberOfChannelsKey : @1, AVSampleRateKey : @16000.0, AVFormatIDKey : @(kAudioFormatAppleIMA4)} error:nil];
        _recorder.delegate = self;
        [_recorder prepareToRecord];
    }
    
    return _recorder;
}

#pragma mark -
#pragma mark AudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

@end
