/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "VenueSectionedDataSource.h"

@implementation EVTVenueSectionedDataSource

#pragma mark - Instance variables

@synthesize dataModel;
@synthesize venueId;

#pragma mark - Constructor

- (id)initWithVenueId:(NSInteger)aVenueId {
    if (self = [super init]) {
        _items = [[NSMutableArray alloc] init];
        _sections = [[NSMutableArray alloc] init];        
        
        self.venueId = aVenueId;
        
        EVTVenueDataModel *vdm = [[EVTVenueDataModel alloc] init];
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
    
    for (EVTVenue *venueItem in modelItems) {
        if (self.venueId == venueItem.venueId) {
            
            TTTableSummaryItem *t0 = [TTTableSummaryItem itemWithText:venueItem.name];
            TTTableLink *t1 = [TTTableLink itemWithText:NSLocalizedString(@"Spectacole",@"VenueLabelEvents") 
                                                    URL:[NSString stringWithFormat:@"tt://event/%d",venueItem.venueId]];
            NSArray *eventItems = [[NSArray alloc] initWithObjects:t0, t1, nil];
            
            TTTableSummaryItem *t2 = [TTTableSummaryItem itemWithText:NSLocalizedString(@"Contact",@"VenueLabelContact")];
            TTTableTextItem *t3 = [TTTableTextItem itemWithText:[[NSUserDefaults standardUserDefaults] 
                                                                 objectForKey:USER_DEFAULTS_CITY_NAME]];
            TTTableTextItem *t4 = [TTTableTextItem itemWithText:venueItem.address];
            TTTableLink *t5 = [TTTableLink itemWithText:venueItem.website URL:venueItem.website];
            NSArray *infoItems = [[NSArray alloc] initWithObjects:t2, t3, t4, t5, nil];
            
            [_sections addObject:@""];
            [_items addObject:eventItems];
            [eventItems release];
            
            [_sections addObject:@""];
            [_items addObject:infoItems];
            [infoItems release];
            
            if (venueItem.lat > 0 && venueItem.lng > 0) {
                TTTableSummaryItem *t6 = [TTTableSummaryItem 
                                          itemWithText:NSLocalizedString(@"Localizare", @"VenueLabelMap")];
                TTTableItem *t7 = [EVTMapTableViewItem itemWithVenue:venueItem];
                NSArray *mapItems = [[NSArray alloc] initWithObjects:t6, t7, nil];
                
                [_sections addObject:@""];
                [_items addObject:mapItems];
                [mapItems release];
            }
            
            break;
        }
    }
}

#pragma mark - TTTableViewDataSource methods

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if([object isKindOfClass:[EVTMapTableViewItem class]])
        return [EVTMapTableViewCell class];
    else
        return [super tableView:tableView cellClassForObject:object];
}

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
