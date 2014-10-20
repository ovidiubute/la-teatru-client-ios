/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "City.h"

#import "VenueMapView.h"
#import "MapAnnotation.h"
#import "Venue.h"

/*
 * EVTMapViewController
 *
 * Controller that manages a map view of all the venues and their annotations.
 *
 */
@interface EVTMapViewController : TTViewController <TTURLRequestDelegate, MKMapViewDelegate> {
    NSMutableArray *venueList;
    EVTVenueMapView *venueMapView;
}

@property (nonatomic, retain) NSMutableArray *venueList;
@property (nonatomic, retain) EVTVenueMapView *venueMapView;

- (void)displayMap;

@end
