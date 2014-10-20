/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EventsJSONDataSource.h"

@implementation EVTEventsJSONDataSource

#pragma mark - Instance variables

@synthesize dataModel;

#pragma mark - Constructors

- (id)init {
    if (self = [super init]) {
        EVTEventDataModel *edm = [[EVTEventDataModel alloc] init];
        self.dataModel = edm;
        [edm release];
    }
    return self;
}

- (id)initWithVenueId:(NSInteger)aVenueId {
    if (self = [super init]) {
        EVTEventDataModel *edm = [[EVTEventDataModel alloc] initWithVenueId:aVenueId];
        self.dataModel = edm;
        [edm release];
    }
    return self;
}

#pragma mark - TTTableViewDataSource methods

- (id<TTModel>)model {
    return dataModel;
}

#pragma mark - UITableViewDataSource methods

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView {
    return [TTTableViewDataSource lettersForSectionsWithSearch:YES summary:NO];
}

#pragma mark - TTListDataSource methods

- (void)tableViewDidLoadModel:(UITableView *)tableView {
    // Get the list of items from the dataModel (received from server or cache)
    NSArray *modelItems = dataModel.items;
    self.items = [NSMutableArray array];
    self.sections = [NSMutableArray array];
    NSMutableDictionary* groups = [NSMutableDictionary dictionary];
    
    // Formatter for dates.
    NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
    [fmt setLocale:[NSLocale currentLocale]];
    NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:
                      [[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULTS_TIME_DELTA] intValue]];
    [fmt setTimeZone:tz];
    [fmt setDateStyle:NSDateFormatterLongStyle];
    [fmt setTimeStyle:NSDateFormatterShortStyle];
    
    // Gregorian calendar...don't care about Julian.
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    // Lots of allocs...let's use a pool.
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Get the name of the venue.
    // Because of the DB data model, we're unable to retrieve the name of the venue directly, just the ID.
    // But if we have any cached venues, look through that.
    NSArray *cachedContent = [[EVTEventsConfig sharedEventsConfig] getCachedData:kEVTURIVenueByCity];
    BOOL haveVenueData = NO;
    if (cachedContent != nil) {
        haveVenueData = YES;
    }
    
    for (EVTEvent *event in modelItems) {
        // List of dates (string).
        NSArray *schedArray = event.scheduleList;
        
        // Text that will be displayed as item caption (list of formatted dates for now).
        NSString *text = [NSString string];
        
        for (NSString *timestamp in schedArray) {
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
            text = [text stringByAppendingFormat:@"%@\n", formattedDate];
        }
        
        NSString *caption = [NSString string];
        if (haveVenueData) {
            for (NSDictionary *dict in cachedContent) {
                EVTVenue *v = [EVTVenue venueWithDictionary:dict];
                if ([v venueId] == [event venueId]) {
                    caption = [v name];
                    break;
                }
            }
        } else {
            caption = nil;
        }
        
        // Final item!
        NSString* letter = [NSString stringWithFormat:@"%C", 
                            [event.title characterAtIndex:0]];
        if ([letter compare:@"A"] == NSOrderedAscending) {
            // Group all non alfabetic chars
            letter = @"...";
        }
        NSMutableArray* section = [groups objectForKey:letter];
        if (!section) {
            section = [NSMutableArray array];
            [groups setObject:section forKey:letter];
        }
        TTTableMessageItem *item =
                [TTTableMessageItem itemWithTitle:event.title
                                          caption:caption
                                             text:text
                                        timestamp:nil
                                         imageURL:nil
                                              URL:[NSString stringWithFormat:@"tt://eventdetails/%d",event.eventId]];
        [section addObject:item];
    }
    [pool drain];
    
    NSArray* letters = [groups.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (NSString* letter in letters) {
        NSArray* items = [groups objectForKey:letter];
        [_sections addObject:letter];
        [_items addObject:items];
    }
}

- (NSString *)titleForLoading:(BOOL)reloading {
	return NSLocalizedString(@"Se încarcă...",@"Loading");
}

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"Nu există spectacole!",@"NoEventData");
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
    TT_RELEASE_SAFELY(dataModel);
    [super dealloc];
}

@end
