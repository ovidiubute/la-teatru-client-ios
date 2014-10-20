/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "VenueDetailsViewController.h"

@implementation EVTVenueDetailsViewController

#pragma mark - Instance variables

@synthesize venueId;

#pragma mark - Constructor

- (id)initWithId:(NSInteger)aVenueId {
    if (self = [super init]) {
        self.venueId = aVenueId;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Detalii teatru",@"VenueInfoTitle");
}

#pragma mark - TTModelViewController methods

- (void)createModel 
{
    EVTVenueSectionedDataSource *venuesDataSource = [[EVTVenueSectionedDataSource alloc] initWithVenueId:venueId];
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
