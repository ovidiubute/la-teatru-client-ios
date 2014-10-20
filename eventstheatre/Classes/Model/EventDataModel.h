/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "extThree20JSON/NSString+SBJSON.h"

#import "Event.h"
#import "EventSchedule.h"

#import "VenueDataModel.h"

@interface EVTEventDataModel : TTURLRequestModel <TTURLRequestDelegate> {
    NSArray *items;
    NSInteger venueId;
}

@property (nonatomic, retain) NSArray *items;
@property (nonatomic) NSInteger venueId;

- (id)initWithVenueId:(NSInteger)aVenueId;
- (void)search:(NSString*)text;

@end
