/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "Venue.h"

@implementation EVTVenue

#pragma mark - Instance variables

@synthesize venueId, cityId, name, lat, lng, website, address;

#pragma mark - Constructors

+ (EVTVenue*)venueWithId:(NSInteger)aVenueId cityId:(NSInteger)aCityId name:(NSString *)aName
                  lat:(double)aLat lng:(double)aLng website:(NSString *)aWebsite 
              address:(NSString *)aAddress;
{
    return [[[self alloc] initWithId:aVenueId 
                              cityId:aCityId 
                                name:aName 
                                 lat:aLat 
                                 lng:aLng
                             website:aWebsite 
                             address:aAddress] autorelease];
}

+ (EVTVenue *)venueWithDictionary:(NSDictionary *)dict 
{
    return [[[self alloc] initWithId:[[dict objectForKey:@"id"] intValue]
                              cityId:[[dict objectForKey:@"cityId"] intValue]
                                name:[dict  objectForKey:@"name"]
                                 lat:[[dict objectForKey:@"latitude"] doubleValue]
                                 lng:[[dict objectForKey:@"longitude"] doubleValue]
                             website:[dict  objectForKey:@"website"] 
                             address:[dict  objectForKey:@"address"]] autorelease];
}

- (id)initWithId:(NSInteger)aVenueId cityId:(NSInteger)aCityId name:(NSString *)aName 
             lat:(double)aLat lng:(double)aLng
         website:(NSString *)aWebsite address:(NSString *)aAddress
{
    if ((self = [super init])) {
        venueId = aVenueId;
        cityId  = aCityId;
        name    = [aName copy];
        lat     = aLat;
        lng     = aLng;
        website = [aWebsite copy];
        address = [aAddress copy];
    }
    return self;
}

#pragma mark - Memory management

- (void)dealloc
{
    [name release];
    [website release];
    [address release];
    [super dealloc];
}

@end
