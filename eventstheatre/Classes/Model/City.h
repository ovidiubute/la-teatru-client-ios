/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "Base.h"

/*
 * EVTCity
 *
 * An immutable value object that represents a single element
 * in the dataset.
 */
@interface EVTCity : EVTBase {
    NSInteger cityId;
    NSString *name;
    double lat;
    double lng;
    NSString *countryCode;
}

@property (nonatomic, readonly)         NSInteger cityId;
@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, readonly)         double lat;
@property (nonatomic, readonly)         double lng;
@property (nonatomic, retain, readonly) NSString *countryCode;

+ (EVTCity*)cityWithDictionary:(NSDictionary*)dict;
+ (EVTCity*)cityWithId:(NSInteger)aCityId name:(NSString *)aName lat:(double)aLat lng:(double)aLng
        countryCode:(NSString *)aCountryCode;
- (id)initWithId:(NSInteger)aCityId name:(NSString *)aName lat:(double)aLat lng:(double)aLng 
     countryCode:(NSString *)aCountryCode;

@end
