/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "VenueJSONDataSource.h"

@implementation EVTVenueJSONDataSource

#pragma mark - Instance variables

@synthesize dataModel;

#pragma mark - Constructor

- (id)init {
    if (self = [super init]) {
        EVTVenueDataModel *vdm = [[EVTVenueDataModel alloc] init];
        self.dataModel = vdm;
        [vdm release];
    }
    return self;
}

#pragma mark - TTTableViewDataSource methods

- (id<TTModel>)model {
    return dataModel;
}

#pragma mark - UITableViewDataSource methods

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView {
    return [TTTableViewDataSource lettersForSectionsWithSearch:YES summary:YES];
}

#pragma mark - TTListDataSource methods

- (void)tableViewDidLoadModel:(UITableView *)tableView {
    NSArray *modelItems = dataModel.items;
    self.items = [NSMutableArray array];
    self.sections = [NSMutableArray array];
    NSMutableDictionary* groups = [NSMutableDictionary dictionary];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (EVTVenue *venueItem in modelItems) {
        NSString* letter = [NSString stringWithFormat:@"%C", 
                            [venueItem.name characterAtIndex:0]];
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
        [TTTableMessageItem itemWithTitle:venueItem.name
                                  caption:venueItem.address
                                     text:venueItem.website
                                timestamp:nil
                                 imageURL:nil
                                      URL:[NSString stringWithFormat:@"tt://venuedetails/%d",venueItem.venueId]];
        
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
	return NSLocalizedString(@"Nu există teatre!",@"NoVenueData");
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
