/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "Venue.h"

@interface EVTMapTableViewItem : TTTableViewItem {
    EVTVenue *venue;
}

@property (nonatomic, retain) EVTVenue *venue;

+ (id)itemWithVenue:(EVTVenue *)v;

@end
