/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EVMapTableViewCell.h"

@implementation EVTMapTableViewCell

@synthesize mapView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
        mapView = [[EVTVenueMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 220)];
        [self.contentView addSubview:mapView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    mapView.frame = CGRectMake(0, 0, 300, 220);
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 220;
}

- (void)setObject:(id)object
{
    [super setObject:object];
    
    EVTMapTableViewItem *item = object;
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = item.venue.lat;
    zoomLocation.longitude = item.venue.lng;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 400, 400);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                        
    [mapView setRegion:adjustedRegion animated:NO]; 
    
    CLLocationCoordinate2D venueLocation;
    venueLocation.latitude = item.venue.lat;
    venueLocation.longitude = item.venue.lng;
    EVTMapAnnotation *annotation = [[[EVTMapAnnotation alloc] initWithCoordinate:venueLocation
                                                                           title:item.venue.name
                                                                        subtitle:item.venue.address 
                                                                         venueId:item.venue.venueId] autorelease];
    [mapView addAnnotation:annotation];
}

- (void)dealloc
{
    TT_RELEASE_SAFELY(mapView);
    [super dealloc];
}

@end
