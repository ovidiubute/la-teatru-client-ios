/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EventSearchDataSource.h"

@implementation EVTEventSearchDataSource

#pragma mark - Instance variables

@synthesize dataModel = _dataModel;

#pragma mark - Constructor

- (id)init {
    if (self = [super init]) {
        _dataModel = [[EVTEventDataModel alloc] init];
        self.model =  _dataModel;
    }
    return self;
}

#pragma mark - TTListDataSource methods

- (void)tableViewDidLoadModel:(UITableView *)tableView {
    self.items = [NSMutableArray array];
    
    NSArray *cachedVenues = [[EVTEventsConfig sharedEventsConfig] getCachedData:kEVTURIVenueByCity];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (EVTEvent *e in _dataModel.items) {        
        NSString *caption = [NSString string];
        for (NSDictionary *venueDict in cachedVenues) {
            EVTVenue *v = [EVTVenue venueWithDictionary:venueDict];
            if ([v venueId] == [e venueId]) {
                caption = [v name];
                break;
            }
        }
        TTTableMessageItem *item = [TTTableMessageItem itemWithTitle:e.title 
                                                             caption:caption
                                                                text:nil 
                                                           timestamp:nil
                                                                 URL:
                                    [NSString stringWithFormat:@"tt://eventdetails/%d", e.eventId]];
        [_items addObject:item];
    }
    [pool drain];
}

- (void)search:(NSString*)text {
    [_dataModel search:text];
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return NSLocalizedString(@"Se încarcă...",@"Loading");
}

- (NSString*)titleForNoData {
    return NSLocalizedString(@"Nu există spectacole",@"EventSearchNoData");
}

- (NSString *)titleForError:(NSError *)error {
	return NSLocalizedString(@"Ne pare rău,",@"VenueDataError");
}

- (NSString *)subtitleForError:(NSError *)error {
	return NSLocalizedString(@"Cererea dvs. nu a putut fi efectuată.",@"VenueDataErrorSubtitle");
}

#pragma mark - Memory management

- (void)dealloc {
    TT_RELEASE_SAFELY(_dataModel);
    [super dealloc];
}

@end
