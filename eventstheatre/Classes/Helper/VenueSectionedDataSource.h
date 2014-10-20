/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EVMapTableViewItem.h"
#import "EVMapTableViewCell.h"

#import "VenueDataModel.h"


/*
 * EVTVenueSectionedDataSource
 *
 * Retrieves data from server and uses extThree20JSON 
 * library to parse the JSON and returns a sectioned data source
 * to view information about a particular venue.
 * 
 * To reduce network usage, this datasource piggy backs on 
 * VenueDataModel and retrieves all venues, and then selects
 * only the desired one (by ID).
 *
 */
@interface EVTVenueSectionedDataSource : TTSectionedDataSource {
    EVTVenueDataModel *dataModel;
    NSInteger venueId;
}

@property (nonatomic, retain) EVTVenueDataModel *dataModel;
@property (nonatomic) NSInteger venueId;

- (id)initWithVenueId:(NSInteger)aVenueId;

@end