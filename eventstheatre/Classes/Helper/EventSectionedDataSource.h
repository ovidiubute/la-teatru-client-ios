/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EventDataModel.h"
#import "Venue.h"

/*
 * EVTEventSectionedDataSource
 *
 * Retrieves data from server and uses extThree20JSON 
 * library to parse the JSON and returns a sectioned data source
 * to view information about a particular event.
 * 
 * To reduce network usage, this datasource piggy backs on 
 * EVTEventDataModel and retrieves all events, and then selects
 * only the desired one (by ID).
 *
 */
@interface EVTEventSectionedDataSource : TTSectionedDataSource {
    EVTEventDataModel *dataModel;
    NSInteger eventId;
}

@property (nonatomic, retain) EVTEventDataModel *dataModel;
@property (nonatomic) NSInteger eventId;

- (id)initWithEventId:(NSInteger)anEventId;

@end