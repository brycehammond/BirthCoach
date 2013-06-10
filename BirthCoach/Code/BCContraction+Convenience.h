//
//  BCContraction+Convenience.h
//  BirthCoach
//
//  Created by Bryce Hammond on 6/9/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCContraction.h"

@interface BCContraction (Convenience)

@property (nonatomic, readonly) NSTimeInterval frequency; //frequency in seconds
@property (nonatomic, readonly) NSTimeInterval duration; //duration in seconds

//finders
+ (BCContraction *)lastContractionBeforeTime:(NSDate *)time;
+ (BCContraction *)lastContraction;
+ (BCContraction *)activeContraction;

//averages
+ (CGFloat)averageFrequencyForLastMinutes:(NSInteger)minutes;
+ (CGFloat)averageDurationForLastMinutes:(NSInteger)minutes;

@end
