/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import <TapkuLibrary/TapkuLibrary.h>

#import "Event.h"
#import "EventDetailsViewController.h"
#import "EVTTableMessageItemCell.h"

/*
 * EVTCalendarViewController
 *
 * Controller that manages the view displaying a calendar of events.
 *
 */
@interface EVTCalendarViewController : TKCalendarMonthTableViewController <TTURLRequestDelegate> {
	NSMutableDictionary *dataDictionary;
    NSMutableArray *dateList; 
}

@property (retain,nonatomic) NSMutableDictionary *dataDictionary;
@property (retain,nonatomic) NSMutableArray *dateList;

@end
