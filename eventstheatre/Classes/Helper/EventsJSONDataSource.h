/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "Event.h"
#import "EventDataModel.h"
#import "Venue.h"

/*
 * EVTEventsJSONDataSource
 *
 * Retrieves data from server and uses extThree20JSON 
 * library to parse the JSON and store
 * it in an array of Event objects.
 *
 */
@interface EVTEventsJSONDataSource : TTSectionedDataSource {
    EVTEventDataModel *dataModel;
}

@property (nonatomic, retain) EVTEventDataModel *dataModel;

- (id)initWithVenueId:(NSInteger)aVenueId;

@end