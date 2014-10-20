/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "CalendarViewController.h"

@implementation EVTCalendarViewController

#pragma mark - Instance variables

@synthesize dateList;
@synthesize dataDictionary;

#pragma mark - Constructor

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        dateList = [[NSMutableArray alloc] init];
        dataDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_CITY_NAME];
    self.title = cityName;
    
    [[EVTEventsConfig sharedEventsConfig] makeAsyncHttpRequest:kEVTURIEventByCity 
                                                   delegate:self 
                                                cachePolicy:TTURLRequestCachePolicyDefault 
                                                     params:nil];
}

#pragma mark - TTURLRequestDelegate methods

/**
 * WARNING: We are treating each date string received from the server
 * as if it was in UTC time! This makes for way easier management but it
 * also means there is no hope of ever seeing events from another timezone.
 * TODO: This will break daylight savings when you are looking at an event
 * from a future time that will have daylight savings in it (and we treat 
 * it as GMT)!!!
 */
- (void)requestDidFinishLoad:(TTURLRequest *)request
{
    NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
    [fmt setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
    
    TTURLJSONResponse *reqResponse = (TTURLJSONResponse *)request.response;
    for (NSDictionary *eventDict in reqResponse.rootObject) {
        EVTEvent *ev = [EVTEvent eventWithDictionary:eventDict];
        // Get list of timestamps.
        NSArray *scheduleList = [eventDict valueForKey:@"scheduleList"];
        for (NSString *timestmap in scheduleList) {
            // We need to store the schedule objects grouped in NSArrays for each NSDate
            // with the note that the NSDate objects will have 00:00:00 +0000 as time!
            // VERY IMPORTANT!
            
            NSDate *d = [fmt dateFromString:timestmap];
            EVTEventSchedule *evSched = [EVTEventSchedule eventScheduleWithEvent:ev date:d];
            
            // Reset to midnight!
            TKDateInformation dateInfo = [d dateInformation];
            dateInfo.hour = 0;
            dateInfo.minute = 0;
            dateInfo.second = 0;
            
            NSDate *midnightDate = [NSDate dateFromDateInformation:dateInfo 
                                                          timeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            
            if ([dataDictionary objectForKey:midnightDate] == nil) {
                NSMutableArray *dateArray = [NSMutableArray array];
                [dateArray addObject:evSched];
                [dataDictionary setObject:dateArray forKey:midnightDate];
            } else {
                NSMutableArray *dateArray = [dataDictionary objectForKey:midnightDate];
                [dateArray addObject:evSched];
                [dataDictionary setObject:dateArray forKey:midnightDate];
            }
   
            NSString *dateString = [midnightDate description];
            NSArray *arr = [dateString componentsSeparatedByString:@" "];
            [self.dateList addObject:[arr objectAtIndex:0]];
        }
    }
    [loopPool drain];
    
    [_monthView reload];
    [_monthView selectDate:[NSDate date]];
}

#pragma mark - TKCalendarMonthViewDelegate methods

- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d 
{
    [self.tableView reloadData];
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d animated:(BOOL)animated {
    [super calendarMonthView:monthView monthDidChange:d animated:animated];
    [self.tableView reloadData];
}

#pragma mark - TKCalendarMonthViewDataSource methods

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{	
	// Initialise empty marks array, this will be populated with TRUE/FALSE in order for each day a marker should be placed on.
	NSMutableArray *marks = [NSMutableArray array];
	
	// Initialise calendar to current type and set the timezone to never have daylight saving
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	// Construct DateComponents based on startDate so the iterating date can be created.
	// Its massively important to do this assigning via the NSCalendar and 
    // NSDateComponents because of daylight saving has been removed 
	// with the timezone that was set above. If you just used "startDate" 
    // directly (ie, NSDate *date = startDate;) as the first iterating date then times 
    // would go up and down based on daylight savings.
	NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | 
                                              NSYearCalendarUnit | NSDayCalendarUnit | 
                                              NSWeekdayCalendarUnit | NSHourCalendarUnit | 
                                              NSSecondCalendarUnit) 
                                    fromDate:startDate];
	NSDate *d = [cal dateFromComponents:comp];
	
	// Init offset components to increment days in the loop by one each time
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setDay:1];
	
    
	// for each date between start date and end date check if they exist in the data array
	while (YES) {
		// Is the date beyond the last date? If so, exit the loop.
		// NSOrderedDescending = the left value is greater than the right
		if ([d compare:lastDate] == NSOrderedDescending) {
			break;
		}
		
		// If the date is in the data array, add it to the marks array, else don't
        NSString *dateString = [d description];
        NSArray *arr = [dateString componentsSeparatedByString:@" "];
		if ([self.dateList containsObject:[arr objectAtIndex:0]]) {
			[marks addObject:[NSNumber numberWithBool:YES]];
		} else {
			[marks addObject:[NSNumber numberWithBool:NO]];
		}
		
		// Increment day using offset components (ie, 1 day in this instance)
		d = [cal dateByAddingComponents:offsetComponents toDate:d options:0];
	}
	
	[offsetComponents release];
	
	return [NSArray arrayWithArray:marks];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{	
	NSArray *ar = [dataDictionary objectForKey:[_monthView dateSelected]];
	if(ar == nil) return 0;
	return [ar count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    EVTTableMessageItemCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EVTTableMessageItemCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                             reuseIdentifier:CellIdentifier];
    }
    
    NSArray *ar = [dataDictionary objectForKey:[_monthView dateSelected]];
    EVTEventSchedule *ev = [ar objectAtIndex:indexPath.row];
    
    // Treat the dates as UTC (even if we know they're not) -- easier display.
    NSTimeZone *currentTimeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    TKDateInformation dateInfo = [ev.date dateInformationWithTimeZone:currentTimeZone];
    
    // Setting the URL here is redundant since this is not a sublcass of
    // TTViewController and we cannot handle the touch event as usual.
    // However setting a URL will force the cell to display a disclosure indicator.
    // Afterwards we will navigate using standard didSelectRowAtIndexPath.
    static NSString *url = @"tt://redundant";

    // Try to get the venue name from cache.
    NSString *venueName = nil;
    NSArray *cachedVenues = [[EVTEventsConfig sharedEventsConfig] getCachedData:kEVTURIVenueByCity];
    if (cachedVenues != nil) {
        for (NSDictionary *venueDict in cachedVenues) {
            EVTVenue *v = [EVTVenue venueWithDictionary:venueDict];
            if ([v venueId] == ev.parentEvent.venueId) {
                venueName = [v name];
                break;
            }
        }
    }
    
    // Final cell item.
    long timeOffset = [[[NSUserDefaults standardUserDefaults] 
                        objectForKey:USER_DEFAULTS_TIME_DELTA] longValue];
    NSDate *properDate = [NSDate dateFromDateInformation:dateInfo 
                           timeZone:[NSTimeZone timeZoneForSecondsFromGMT:timeOffset]];
    [cell setObject:[TTTableMessageItem itemWithTitle:ev.parentEvent.title 
                                              caption:((venueName != nil) ? venueName : nil)
                                                 text:nil 
                                            timestamp:properDate
                                                  URL:url]];
    
    return cell;	
}

#pragma mark - UITableViewDelegate methods

/**
 * Display a details screen for the selected event schedule/row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *ar = [dataDictionary objectForKey:[_monthView dateSelected]];
    EVTEventSchedule *eventSchedule = [ar objectAtIndex:indexPath.row];
    
    NSInteger eventId = eventSchedule.parentEvent.eventId;
    NSString *url = [NSString stringWithFormat:@"tt://eventdetails/%d",eventId];
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:url]];
}

#pragma mark - Memory management

- (void) dealloc
{
    TT_RELEASE_SAFELY(dataDictionary);
    TT_RELEASE_SAFELY(dateList);
    [super dealloc];
}

@end