/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "City.h"

@implementation EVTCity

#pragma mark - Instance variables

@synthesize cityId, name, lat, lng, countryCode;

#pragma mark - Constructors

+ (EVTCity*)cityWithDictionary:(NSDictionary *)dict
{
    return [EVTCity cityWithId:[[dict objectForKey:@"id"] intValue] 
                       name:[dict  objectForKey:@"name"] 
                        lat:[[dict objectForKey:@"latitude"] doubleValue]
                        lng:[[dict objectForKey:@"longitude"] doubleValue]
                countryCode:[dict  objectForKey:@"countryCode"]];
}

+ (EVTCity*)cityWithId:(NSInteger)aCityId name:(NSString *)aName lat:(double)aLat lng:(double)aLng
        countryCode:(NSString *)aCountryCode;
{
    return [[[[self class] alloc] initWithId:aCityId 
                                        name:aName 
                                         lat:aLat 
                                         lng:aLng 
                                 countryCode:aCountryCode] autorelease];
}

- (id)initWithId:(NSInteger)aCityId name:(NSString *)aName lat:(double)aLat lng:(double)aLng 
     countryCode:(NSString *)aCountryCode
{
    if ((self = [super init])) {
        cityId      = aCityId;
        name        = [aName copy];
        lat         = aLat;
        lng         = aLng;
        countryCode = [aCountryCode copy];
    }
    return self;
}

#pragma mark - Memory management

- (void)dealloc
{
    [name release];
    [countryCode release];
    [super dealloc];
}

@end
