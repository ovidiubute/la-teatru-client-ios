/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */
#import "VenueDataModel.h"

/*
 * EVTVenueSearchDataSource
 *
 * Retrieves data from server and uses extThree20JSON 
 * library to parse the JSON and store
 * it in an array of Venue objects.
 *
 */
@interface EVTVenueSearchDataSource : TTListDataSource {
    EVTVenueDataModel *dataModel;
}

@property (nonatomic, readonly) EVTVenueDataModel *dataModel;

@end
