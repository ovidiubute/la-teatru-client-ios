/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "Venue.h"

@interface EVTVenueDataModel : TTURLRequestModel <TTURLRequestDelegate> {
    NSString *rawResponse; 
    NSArray *items;
}

@property (nonatomic, retain) NSArray *items;

- (void)search:(NSString*)text;

@end
