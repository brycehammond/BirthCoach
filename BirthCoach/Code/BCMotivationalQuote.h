//
//  BCMotivationalQuote.h
//  BirthCoach
//
//  Created by Bryce Hammond on 7/30/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BCMotivationalQuote : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic) int32_t position;

@end
