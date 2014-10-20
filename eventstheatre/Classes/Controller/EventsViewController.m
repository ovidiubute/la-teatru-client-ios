/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EventsViewController.h"

@implementation EVTEventsViewController

#pragma mark - Instance variables

@synthesize venueId;

#pragma mark - Constructors

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.venueId = -1;
    }
    return self;
}

- (id)initWithVenueId:(NSInteger)aVenueId
{
    if (self = [super init]) {
        self.venueId = aVenueId;
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Spectacole";
    
    TTTableViewController* searchController = [[TTTableViewController alloc] init];
    EVTEventSearchDataSource *eds = [[EVTEventSearchDataSource alloc] init];
    searchController.dataSource = eds;
    TT_RELEASE_SAFELY(eds);
    self.searchViewController = searchController;
    TT_RELEASE_SAFELY(searchController);
    self.tableView.tableHeaderView = _searchController.searchBar;
}

#pragma mark - TTModelViewController methods

- (void)createModel 
{
    id eventsDataSource;
    if (venueId == -1) {
        eventsDataSource = [[EVTEventsJSONDataSource alloc] init];
    } else {
        eventsDataSource = [[EVTEventsJSONDataSource alloc] initWithVenueId:self.venueId];
    }
    self.dataSource = eventsDataSource;
    TT_RELEASE_SAFELY(eventsDataSource);
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [super dealloc];
}

@end
