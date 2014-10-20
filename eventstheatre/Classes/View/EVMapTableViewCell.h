/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EVMapTableViewItem.h"
#import "MapAnnotation.h"
#import "VenueMapView.h"

@interface EVTMapTableViewCell : TTTableViewCell {
    EVTVenueMapView *mapView;
}

@property (nonatomic, retain) EVTVenueMapView *mapView;

@end
