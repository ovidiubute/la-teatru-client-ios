/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "Base.h"
#import "Event.h"

/*
 * EVTEventSchedule
 *
 * An immutable value object that represents a single element
 * in the dataset.
 */
@interface EVTEventSchedule : EVTBase {
    NSDate *date;
    EVTEvent  *parentEvent;
}

@property (nonatomic, retain, readonly) NSDate *date;
@property (nonatomic, retain, readonly) EVTEvent *parentEvent;

+ (EVTEventSchedule*)eventScheduleWithEvent:(EVTEvent*)anEvent date:(NSDate *)aDate;
- (id)initWithEvent:(EVTEvent *)anEvent date:(NSDate *)aDate;

@end
