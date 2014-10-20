/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EventSchedule.h"

@implementation EVTEventSchedule

#pragma mark - Instance variables

@synthesize date, parentEvent;

#pragma mark - Constructors

+ (EVTEventSchedule*)eventScheduleWithEvent:(EVTEvent*)anEvent date:(NSDate *)aDate;
{
    return [[[EVTEventSchedule alloc] initWithEvent:anEvent date:aDate] autorelease];
}

- (id)initWithEvent:(EVTEvent *)anEvent date:(NSDate *)aDate
{
    if ((self = [super init])) {
        parentEvent = [anEvent retain];
        date        = [aDate retain];
    }
    return self;
}

#pragma mark - Memory management

- (void)dealloc
{
    [date release];
    [parentEvent release];
    [super dealloc];
}

@end
