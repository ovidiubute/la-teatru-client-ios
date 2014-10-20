/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "VenueDataModel.h"

/*
 * EVTVenueJSONDataSource
 *
 * Retrieves data from server and uses extThree20JSON 
 * library to parse the JSON and store
 * it in an array of Venue objects.
 *
 */
@interface EVTVenueJSONDataSource : TTSectionedDataSource {
    EVTVenueDataModel *dataModel;
}

@property (nonatomic, retain) EVTVenueDataModel *dataModel;

@end
