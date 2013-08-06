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
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@end

@implementation BCAudioAlertEditViewController

@synthesize reminder = _reminder;
@synthesize recorder = _recorder;
@synthesize player = _player;

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

- (IBAction)recordStop:(id)sender
{
    if([self.recorder isRecording])
    {
        [self.recorder stop];
        self.currentAudioData = [[NSData alloc] initWithContentsOfURL:self.recorder.url];
        self.player = nil; //clear out the player so it loads the recorded audio
        self.playButton.hidden = NO;
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    else
    {
        [self.recorder deleteRecording];
        [self.recorder record];
        self.playButton.hidden = YES;
        [self.recordButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

- (AVAudioPlayer *)player
{
    if(nil == _player)
    {
        _player = [[AVAudioPlayer alloc] initWithData:self.currentAudioData error:nil];
        _player.delegate = self;
        [_player prepareToPlay];
    }
    
    return _player;
}

- (AVAudioRecorder *)recorder
{
    if(nil == _recorder)
    {
        NSString *recordFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"BirthCoach_reminder.caf"];
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
