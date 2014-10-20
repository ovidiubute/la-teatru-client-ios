/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "Base.h"

/*
 * EVTVenue
 *
 * An immutable value object that represents a single element
 * in the dataset.
 */
@interface EVTVenue : EVTBase {
    NSInteger venueId;
    NSInteger cityId;
    NSString *name;
    double lat;
    double lng;
    NSString *website;
    NSString *address;
}

@property (nonatomic, readonly) NSInteger venueId;
@property (nonatomic, readonly) NSInteger cityId;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) double lat;
@property (nonatomic, readonly) double lng;
@property (nonatomic, readonly) NSString *website;
@property (nonatomic, readonly) NSString *address;

+ (EVTVenue *)venueWithDictionary:(NSDictionary *)dict;
+ (EVTVenue*)venueWithId:(NSInteger)aVenueId cityId:(NSInteger)aCityId name:(NSString *)aName
                  lat:(double)aLat lng:(double)aLng website:(NSString *)aWebsite 
              address:(NSString *)aAddress;
- (id)initWithId:(NSInteger)aVenueId cityId:(NSInteger)aCityId name:(NSString *)aName 
             lat:(double)aLat lng:(double)aLng
         website:(NSString *)aWebsite address:(NSString *)aAddress;

@end
