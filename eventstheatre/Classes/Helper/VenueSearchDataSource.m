/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "VenueSearchDataSource.h"

@implementation EVTVenueSearchDataSource

#pragma mark - Instance variables

@synthesize dataModel = _dataModel;

#pragma mark - Constructor

- (id)init {
    if (self = [super init]) {
        _dataModel = [[EVTVenueDataModel alloc] init];
        self.model =  _dataModel;
    }
    return self;
}

#pragma mark - TTListDataSource methods

- (void)tableViewDidLoadModel:(UITableView *)tableView {
    self.items = [NSMutableArray array];
    
    for (EVTVenue *v in _dataModel.items) {
        TTTableItem *item = [TTTableTextItem itemWithText:v.name 
                                                      URL:[NSString stringWithFormat:@"tt://venuedetails/%d", v.venueId]];
        [_items addObject:item];
    }
}

- (void)search:(NSString*)text {
    [_dataModel search:text];
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return NSLocalizedString(@"Se încarcă...",@"Loading");
}

- (NSString*)titleForNoData {
    return NSLocalizedString(@"Nu există teatre","VenueSearchNoData");
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
