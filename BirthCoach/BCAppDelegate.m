//
//  BCAppDelegate.m
//  BirthCoach
//
//  Created by Bryce Hammond on 6/9/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCAppDelegate.h"
#import "TestFlight.h"
#import "BCMotivationalQuote+Convenience.h"
#import "BCAudioReminder.h"
#import <AVFoundation/AVFoundation.h>

@implementation BCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"BirthCoach.sqlite"];
    [TestFlight takeOff:@"8c004250-8cbf-49c9-938a-9b6a29f9157a"];
    
    //default to keeping the display on all the time (no idle)
    if([[NSUserDefaults standardUserDefaults] objectForKey:kDisplayKeepOnKey] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDisplayKeepOnKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //default to having audio reminders on
    if([[NSUserDefaults standardUserDefaults] objectForKey:kAudioRemindersOnKey] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAudioRemindersOnKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //create the default entities
        for(NSNumber *time in @[@30,@60,@90])
        {
            BCAudioReminder *reminder = [BCAudioReminder createEntity];
            reminder.seconds = time;
            NSData *audioData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:time.stringValue ofType:@"m4a"]];
            reminder.audioData = audioData;
        }
        
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:nil];
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:[[NSUserDefaults standardUserDefaults] boolForKey:kDisplayKeepOnKey]];
    
    //Load up our quotes if we haven't already
    [BCMotivationalQuote loadQuotes];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBackgroundingNotification object:self];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kForegroundingNotification object:self];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
