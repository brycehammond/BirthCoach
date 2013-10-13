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
    self.playButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:self.playButton.titleLabel.font.pointSize];
    self.recordButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:self.recordButton.titleLabel.font.pointSize];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
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
        [self.playButton setImage:[UIImage imageNamed:@"play-icon"] forState:UIControlStateNormal];
        [self.playButton setTitle:@"Playback Reminder" forState:UIControlStateNormal];
    }
    else
    {
        [self.player play];
        [self.playButton setImage:[UIImage imageNamed:@"stop-icon"] forState:UIControlStateNormal];
        [self.playButton setTitle:@"Stop Playback" forState:UIControlStateNormal];
    }
}

- (IBAction)recordStop:(id)sender
{
    if([self.recorder isRecording])
    {
        [self.recorder stop];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        self.player = nil; //clear out the player so it loads the recorded audio
        self.playButton.hidden = NO;
        [self.recordButton setImage:[UIImage imageNamed:@"record-icon"] forState:UIControlStateNormal];
        [self.recordButton setTitle:@"Record Reminder" forState:UIControlStateNormal];
    }
    else
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
        [self.recorder record];
        self.playButton.hidden = YES;
        [self.recordButton setImage:[UIImage imageNamed:@"stop-icon"] forState:UIControlStateNormal];
        [self.recordButton setTitle:@"Stop Recording" forState:UIControlStateNormal];
    }
}

- (IBAction)save:(id)sender
{
    self.reminder.audioData = self.currentAudioData;
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
        NSError *error = nil;
        NSString *recordFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"BirthCoach_reminder.caf"];
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:recordFilePath] settings:@{AVNumberOfChannelsKey : @1, AVSampleRateKey : @16000.0, AVFormatIDKey : @(kAudioFormatAppleIMA4)} error:&error];
        _recorder.delegate = self;
    }
    
    return _recorder;
}

#pragma mark -
#pragma mark AudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playButton setImage:[UIImage imageNamed:@"play-icon"] forState:UIControlStateNormal];
    [self.playButton setTitle:@"Playback Reminder" forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark AudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)success
{
    if(success)
    {
        self.currentAudioData = [[NSData alloc] initWithContentsOfURL:recorder.url];
    }
}


@end
