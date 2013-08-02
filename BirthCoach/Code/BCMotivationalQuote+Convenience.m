//
//  BCMotivationalQuote+Convenience.m
//  BirthCoach
//
//  Created by Bryce Hammond on 8/2/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCMotivationalQuote+Convenience.h"

@implementation BCMotivationalQuote (Convenience)

+ (void)loadQuotes
{
    if([BCMotivationalQuote countOfEntities] == 0)
    {
        //load up the quotes from the plist
        NSArray *quotesStrings = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Motivational Quotes" ofType:@"plist"]];
        NSUInteger quotePosition = 1;
        for(NSString *quoteString in quotesStrings)
        {
            BCMotivationalQuote *quote = [BCMotivationalQuote createEntity];
            quote.position = quotePosition;
            quote.text = quoteString;
        }
        
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
    }
}

@end
