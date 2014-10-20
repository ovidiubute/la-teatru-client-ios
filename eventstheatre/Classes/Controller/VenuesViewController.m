/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "VenuesViewController.h"

@implementation EVTVenuesViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_CITY_NAME];
    self.title = [NSString stringWithFormat:@"Teatre în %@",cityName];
    
    TTTableViewController* searchController = [[TTTableViewController alloc] init];
    EVTVenueSearchDataSource *vds = [[EVTVenueSearchDataSource alloc] init];
    searchController.dataSource = vds;
    TT_RELEASE_SAFELY(vds);
    self.searchViewController = searchController;
    TT_RELEASE_SAFELY(searchController);
    self.tableView.tableHeaderView = _searchController.searchBar;
}

#pragma mark - TTModelViewController methods

- (void)createModel 
{
    EVTVenueJSONDataSource *venuesDataSource = [[EVTVenueJSONDataSource alloc] init];
    self.dataSource = venuesDataSource;
    TT_RELEASE_SAFELY(venuesDataSource);
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
