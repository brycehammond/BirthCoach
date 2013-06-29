//
//  BCContraction+Convenience.m
//  BirthCoach
//
//  Created by Bryce Hammond on 6/9/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCContraction+Convenience.h"

@implementation BCContraction (Convenience)

- (NSTimeInterval)frequency
{
    //frequency is the time between the start of one contraction and the start of the next
    
    //get the previous contraction
    BCContraction *prevContraction = [BCContraction lastContractionBeforeTime:self.startTime];
    
    if(nil == prevContraction)
    {
        return 0;
    }
    
    NSTimeInterval frequency = [self.startTime timeIntervalSinceDate:prevContraction.startTime];
    return frequency;
}

- (NSTimeInterval)duration
{
    return [self.endTime timeIntervalSinceDate:self.startTime];
}

+ (BCContraction *)lastContractionBeforeTime:(NSDate *)time
{
    return [BCContraction findFirstWithPredicate:[NSPredicate predicateWithFormat:@"startTime < %@ AND endTime != nil",time] sortedBy:@"startTime" ascending:NO];
}

+ (BCContraction *)lastContraction
{
    return [BCContraction lastContractionBeforeTime:[NSDate date]];
}

+ (BCContraction *)activeContraction
{
    return [BCContraction findFirstWithPredicate:[NSPredicate predicateWithFormat:@"endTime = nil"] sortedBy:@"startTime" ascending:NO];
}

+ (NSTimeInterval)averageFrequencyForLastMinutes:(NSInteger)minutes
{
    NSArray *contractions = [BCContraction findAllSortedBy:@"startTime" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"endTime != nil AND endTime >= %@", [[NSDate date] dateByAddingTimeInterval:-(minutes * 60)]]];
    
    if(contractions.count == 0)
    {
        return 0;
    }
    
    NSTimeInterval summedFrequency = 0;
    NSInteger totalContractions = 0;
    BCContraction *previousContraction = nil;
    for(BCContraction *contraction in contractions)
    {
        if(nil == previousContraction)
        {
            //if there was a contraction before the first one then inclue the frequency in the average
            summedFrequency += contraction.frequency;
        }
        else
        {
            summedFrequency += [contraction.startTime timeIntervalSinceDate:previousContraction.startTime];
        }
        
        if(summedFrequency > 0)
        {
            ++totalContractions;
        }
        
        previousContraction = contraction;
    }
    
    return summedFrequency / totalContractions;
}

+ (NSTimeInterval)averageDurationForLastMinutes:(NSInteger)minutes
{
    NSArray *contractions = [BCContraction findAllSortedBy:@"startTime" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"endTime != nil AND endTime >= %@", [[NSDate date] dateByAddingTimeInterval:-(minutes * 60)]]];
    
    NSTimeInterval totalDuration = 0;
    for(BCContraction *contraction in contractions)
    {
        totalDuration += contraction.duration;
    }
    
    if(0 == totalDuration)
    {
        return 0; //prevent a 0/0 error
    }
    
    return totalDuration / contractions.count;
    
}

+ (NSInteger)numberInLastMinutes:(NSInteger)minutes
{
    return [BCContraction countOfEntitiesWithPredicate:[NSPredicate predicateWithFormat:@"endTime != nil AND endTime <= %@", [[NSDate date] dateByAddingTimeInterval:-(minutes * 60)]]];
}

@end
