/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EVTBaseDetailsViewController.h"

#import "VenueSectionedDataSource.h"

/*
 * EVTVenueDetailsController
 *
 * Controller that manages the screen displaying venue info.
 *
 */
@interface EVTVenueDetailsViewController : EVTBaseDetailsViewController {
    NSInteger venueId;
}

@property (nonatomic) NSInteger venueId;

- (id)initWithId:(NSInteger)aVenueId;

@end
