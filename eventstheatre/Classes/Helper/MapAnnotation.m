/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "MapAnnotation.h"

@implementation EVTMapAnnotation

#pragma mark - Instance variables

@synthesize coordinate, title, subtitle, venueId;

#pragma mark - Constructor

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord 
                   title:(NSString *)titl 
                subtitle:(NSString *)sub 
                 venueId:(NSInteger)vId
{
    if (self = [super init]) {
        title = [titl copy];
        subtitle = [sub copy];
        coordinate = coord;
        venueId = vId;
    }
    return self;
}

#pragma mark - Memory management

- (void)dealloc 
{
    [title release];
    [subtitle release];
    [super dealloc];
}

@end
