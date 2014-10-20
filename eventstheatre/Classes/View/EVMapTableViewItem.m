/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EVMapTableViewItem.h"

@implementation EVTMapTableViewItem

@synthesize venue;

+ (id)itemWithVenue:(EVTVenue *)v 
{
    EVTMapTableViewItem *item = [[[self alloc] init] autorelease];
    item.venue = v;
        
    return item;
}

- (id)init 
{
    if (self = [super init]) {
        venue = nil;
    }
    return self;
}

- (void)dealloc 
{
    TT_RELEASE_SAFELY(venue);
    [super dealloc];
}

@end
