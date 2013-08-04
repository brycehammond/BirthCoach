//
//  BCAudioReminder.h
//  BirthCoach
//
//  Created by Bryce Hammond on 8/4/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BCAudioReminder : NSManagedObject

@property (nonatomic, retain) NSNumber * seconds;
@property (nonatomic, retain) NSData * audioData;

@end
