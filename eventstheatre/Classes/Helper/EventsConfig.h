/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "UIDevice+Hardware.h"

/*
 * EVTEventsConfig
 *
 * Global application singleton to store configuration and 
 * widely used methods.
 *
 */
@interface EVTEventsConfig : NSObject {
    NSDictionary *configData;
    NSMutableDictionary *httpHeaders;
}

@property (nonatomic, retain) NSDictionary *configData;
@property (nonatomic, retain) NSMutableDictionary *httpHeaders;

+ (EVTEventsConfig*)sharedEventsConfig;
- (NSArray *)getCachedData:(EVTWebserviceType)requestType;
- (BOOL)makeAsyncHttpRequest:(EVTWebserviceType)requestType 
                    delegate:(id)delegateObject
                 cachePolicy:(TTURLRequestCachePolicy)three20CachePolicy
                      params:(id)param, ... ;
- (void)purgeThree20UrlCache;
- (long)getEventsRequestTimestamp;

@end
