/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EventsJSONDataSource.h"
#import "EventSearchDataSource.h"

#import "EVTBaseTableViewController.h"

/*
 * EVTEventsViewController
 *
 * Controller that manages the list of venues.
 *
 */
@interface EVTEventsViewController : EVTBaseTableViewController {
    NSInteger venueId;
}

@property (nonatomic) NSInteger venueId;

@end