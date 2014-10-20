/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import <TapkuLibrary/TapkuLibrary.h>

#import "EventDataModel.h"

#import "EVTTableMessageItemCell.h"
/*
 * EVTEventsSearchDataSource
 *
 * Retrieves data from server and uses extThree20JSON 
 * library to parse the JSON and store
 * it in an array of Event objects.
 *
 */
@interface EVTEventSearchDataSource : TTListDataSource {
    EVTEventDataModel *dataModel;
}

@property (nonatomic, readonly) EVTEventDataModel *dataModel;

@end
