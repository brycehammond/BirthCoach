//
//  BCTimeIntervalFormatter.m
//  BirthCoach
//
//  Created by Bryce Hammond on 6/29/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCTimeIntervalFormatter.h"

@implementation BCTimeIntervalFormatter

+ (NSString *)timeStringForInterval:(NSTimeInterval)interval
{
    if(interval < 1)
    {
        return @"--:--";
    }
    else if(interval < 3600)
    {
        return [NSString stringWithFormat:@"%02i:%02i",(int)interval / 60, (int)interval % 60];
    }
    else
    {
        return [NSString stringWithFormat:@"%i:%02i:%02i",(int)interval / 3600, ((int)interval % 3600) / 60, (int)interval % 60];
    }
}

@end
