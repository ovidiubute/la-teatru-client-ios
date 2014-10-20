/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import <MapKit/MapKit.h>

/*
 * MapAnnotation
 *
 * Represents an annotation used in the MapViewController class.
 * 
 */
@interface EVTMapAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    NSInteger venueId;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly) NSInteger venueId;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate 
                   title:(NSString *)titl 
                subtitle:(NSString *)sub 
                 venueId:(NSInteger)vId;

@end
