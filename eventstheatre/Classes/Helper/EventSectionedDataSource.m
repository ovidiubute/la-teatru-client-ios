/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EventSectionedDataSource.h"

@implementation EVTEventSectionedDataSource

#pragma mark - Instance variables

@synthesize dataModel;
@synthesize eventId;

#pragma mark - Constructor

- (id)initWithEventId:(NSInteger)anEventId {
    if (self = [super init]) {
        _items = [[NSMutableArray alloc] init];
        _sections = [[NSMutableArray alloc] init];        
        self.eventId = anEventId;
        EVTEventDataModel *vdm = [[EVTEventDataModel alloc] init];
        self.dataModel = vdm;
        TT_RELEASE_SAFELY(vdm);
    }
    return self;
}

#pragma mark - TTTableViewDataSource methods

- (id<TTModel>)model {
    return dataModel;
}

#pragma mark - TTSectionedDataSource methods

- (void)tableViewDidLoadModel:(UITableView *)tableView {
    [super tableViewDidLoadModel:tableView];
    
    NSArray *modelItems = dataModel.items;

    for (EVTEvent *eventItem in modelItems) {
        if (self.eventId == eventItem.eventId) {
            BOOL haveVenueData = NO;
            NSString *venueName = nil;
            NSArray *cachedVenues = [[EVTEventsConfig sharedEventsConfig] getCachedData:kEVTURIVenueByCity];
            if (cachedVenues != nil) {
                haveVenueData = YES;
                
                for (NSDictionary  *cachedVenueDict in cachedVenues) {
                    EVTVenue *v = [EVTVenue venueWithDictionary:cachedVenueDict];
                    if ([v venueId] == eventItem.venueId) {
                        venueName = [v name];
                    }
                }
            } 
            
            id t0;
            if ([eventItem.title length] < 30) {
                t0 = [TTTableSummaryItem itemWithText:eventItem.title];
            } else {
                t0 = [TTTableTextItem itemWithText:eventItem.title];
            }
            id infoItems;
            
            if (haveVenueData) {
                // We got the venue name.
                TTTableLink *t1 = [TTTableLink itemWithText:venueName URL:
                                   [NSString stringWithFormat:@"tt://venuedetails/%d", eventItem.venueId]];
                infoItems = [[NSArray alloc] initWithObjects:t0, t1, nil];
            } else {
                // We don't have the venue name at this stage.
                infoItems = [[NSArray alloc] initWithObjects:t0, nil];
            }
            
            NSMutableArray *scheduleTableItems = [NSMutableArray 
                                                  arrayWithCapacity:1 + [eventItem.scheduleList count]];
            TTTableSummaryItem *t2 = [TTTableSummaryItem 
                                      itemWithText:NSLocalizedString(@"Program",@"EventLabelSchedule")];
            [scheduleTableItems addObject:t2];
            
            // Formatter for dates.
            NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
            [fmt setLocale:[NSLocale currentLocale]];
            NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:
                              [[[NSUserDefaults standardUserDefaults] 
                                valueForKey:USER_DEFAULTS_TIME_DELTA] intValue]];
            [fmt setTimeZone:tz];
            [fmt setDateStyle:NSDateFormatterLongStyle];
            [fmt setTimeStyle:NSDateFormatterShortStyle];
                        
            // Gregorian calendar...don't care about Julian.
            NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] 
                                     autorelease];
            
            // Lots of allocs...let's use a pool.
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

            for (NSString *timestamp in eventItem.scheduleList) {
                // Split the date and form our own NSDate object.
                // The current format as received from the server is:
                // yyyy-mm-dd HH:ii:ss (MySQL default).
                NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
                
                NSRange yearDateRange = NSMakeRange(0, 4);
                NSString *year = [timestamp substringWithRange:yearDateRange];
                [components setYear:[year integerValue]];
                
                NSRange monthDateRange = NSMakeRange(5, 2);
                NSString *month = [timestamp substringWithRange:monthDateRange];
                [components setMonth:[month integerValue]];
                
                NSRange dayDateRange = NSMakeRange(8, 2);
                NSString *day = [timestamp substringWithRange:dayDateRange];
                [components setDay:[day integerValue]];
                
                NSRange hourDateRange = NSMakeRange(11, 2);
                NSString *hour = [timestamp substringWithRange:hourDateRange];
                [components setHour:[hour integerValue]];
                
                NSRange minuteDateRange = NSMakeRange(14, 2);
                NSString *minute = [timestamp substringWithRange:minuteDateRange];
                [components setMinute:[minute integerValue]];
                
                NSDate *finalDate = [gregorian dateFromComponents:components];
                NSString *formattedDate = [fmt stringFromDate:finalDate];
                 
                // Send an eventSchedule object along so we can use it later to
                // add an EventKit event to the calendar
                // DO NOT set the URL here, we will manually redirect on click later in the
                // details view controller.
                EVTEventSchedule *itemSchedule = [EVTEventSchedule eventScheduleWithEvent:eventItem 
                                                                                     date:finalDate];
                TTTableLink *tableTextItem = [TTTableLink itemWithText:formattedDate URL:nil];
                if (venueName != nil) {
                    tableTextItem.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                              itemSchedule, @"scheduleObject",
                                              venueName, @"venueName",
                                              nil];
                } else {
                    tableTextItem.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                              itemSchedule, @"scheduleObject", 
                                              nil];
                }
                [scheduleTableItems addObject:tableTextItem];
            }
        
            [pool drain];
            
            [_sections addObject:@""];
            [_items addObject:infoItems];
            [infoItems release];
            
            [_sections addObject:@""];
            [_items addObject:scheduleTableItems];
            
            // Bail.
            break;
        }
    }
}

#pragma mark - TTTableViewDataSource methods

- (NSString *)titleForLoading:(BOOL)reloading {
	return NSLocalizedString(@"Se încarcă...",@"Loading");
}

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"Nu există informații suplimentare!",@"NoSpecificVenueData");
}

- (NSString *)titleForError:(NSError *)error {
	return NSLocalizedString(@"Ne pare rău,",@"VenueDataError");
}

- (NSString *)subtitleForError:(NSError *)error {
	return NSLocalizedString(@"Cererea dvs. nu a putut fi efectuată.",@"VenueDataErrorSubtitle");
}

#pragma mark - Memory management

- (void)dealloc
{
    [super dealloc];
    [dataModel release];
    [_items release];
    [_sections release];
}

@end