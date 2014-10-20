/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EventsConfig.h"

@implementation EVTEventsConfig
    
#pragma mark - Instance variables

@synthesize configData, httpHeaders;

/**
 * Singleton object.
 */
static EVTEventsConfig *_sharedEventsConfig = nil;

#pragma mark - Constructors

/**
 * Allocate a new instance or return existing one.
 */
+ (id)alloc 
{
    @synchronized([EVTEventsConfig class])
    {
        NSAssert(_sharedEventsConfig == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedEventsConfig = [super alloc];
        return _sharedEventsConfig;
    }
}

/**
 * Post-allocation initialization.
 */
- (id)init
{
    self = [super init];
    if (self) {
        // HTTP headers that will be sent with EVERY request.
        // App version, device name and device unique identifier.
        [self setHttpHeaders:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                              EVT_APPVERSION,
                              EVT_HEADER_APPVERSION,
                              [NSString stringWithFormat:@"%@|%@",
                               [[UIDevice currentDevice] platformString],
                               [[UIDevice currentDevice] systemVersion]],
                              EVT_HEADER_MODEL,
                              [[UIDevice currentDevice] uniqueIdentifier],
                              EVT_HEADER_UID,
                              @"application/json",
                              @"Content-Type",
                              nil]];
    }
    
    return self;
}

/**
 * Returns singleton instance or calls allocation of new one.
 */
+ (id)sharedEventsConfig 
{
    @synchronized(self) {
        if (_sharedEventsConfig == nil)
            _sharedEventsConfig = [[self alloc] init];
    }
    return _sharedEventsConfig;
}

#pragma mark - Public methods

/**
 * Deletes all Three20 cache files in Library/Caches/Three20 dir.
 */
- (void)purgeThree20UrlCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *finalPath = [cachesDirectory stringByAppendingPathComponent:@"Three20"];
    NSArray *urlCacheFiles = [fileManager contentsOfDirectoryAtPath:finalPath error:&error];
    
    if (error == nil) {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate* now = [NSDate date];
        for (NSString *file in urlCacheFiles) {
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:[finalPath stringByAppendingPathComponent:file] 
                                                                        error:&error];
            if (error == nil) {
                NSDate *creationDate = [fileAttributes objectForKey:NSFileCreationDate];

                int differenceInDays =
                [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:now] - 
                [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:creationDate];
                
                if (differenceInDays > EVT_MAX_THREE20_URL_CACHE_DURATION) {
                    [fileManager removeItemAtPath:[finalPath stringByAppendingPathComponent:file] error:&error];
                    if (error != nil) continue;
                }
            }
        }
    }
}

/**
 * Pick timestamp to send to server when retrieving events list.
 * !DEPRECATED!
 */
- (long)getEventsRequestTimestamp
{
    // Using a different timestamp each time will break the caching system..
    // SO, we store the timestamp in NSUserDefaults after we make a request,
    // and each subsequent request will check if that timestamp is older than
    // CACHE_DURATION_EVENT_CITY_BY_COUNTRY, in which case it's time to make a real request.
    long serverTimeOffset = 0.0f;
    long adjustedTimestamp = 0.0f;
    
    // Need server time offset first.
    serverTimeOffset = [[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULTS_TIME_DELTA] longValue];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULTS_EVENTS_LAST_UPDATE] == nil) {
        // No cache, get current timestamp, adjust with server offset and store the timestamp in nsuserdefaults
        // DO NOT add the server offset because it may change between retrievals (not likely but still..)
        adjustedTimestamp = [[NSDate date] timeIntervalSince1970] + serverTimeOffset;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] 
                                                 forKey:USER_DEFAULTS_EVENTS_LAST_UPDATE];
    } else {
        // Cached value found in user defaults -- check if it's older than CACHE_DURATION_EVENT_LIST_GLOBAL
        long cachedUpdateTimestamp = [[[NSUserDefaults standardUserDefaults] 
                                       valueForKey:USER_DEFAULTS_EVENTS_LAST_UPDATE] longValue];
        long presentTimestamp = [[NSDate date] timeIntervalSince1970];
        if (presentTimestamp - cachedUpdateTimestamp >= TT_CACHE_DURATION_EVENT_BY_CITY) {
            // Cache is too old! Use present timestamp + offset and save the value to nsuserdefaults
            adjustedTimestamp = [[NSDate date] timeIntervalSince1970] + serverTimeOffset;
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithDouble:adjustedTimestamp] 
                                                     forKey:USER_DEFAULTS_EVENTS_LAST_UPDATE];
        } else {
            // Cache is OK! Use the value.
            adjustedTimestamp = cachedUpdateTimestamp + serverTimeOffset;
        }
    }
    return adjustedTimestamp;
}

/**
 * Returns locally cached response from previous requests.
 * We call this whenever we want a synchronous response from cache,
 * so we never make an http request. If the cache is expired we get nil.
 */
- (NSArray *)getCachedData:(EVTWebserviceType)requestType
{
    NSData *cachedData = nil;
    NSString *parsedData = nil;
    NSInteger defaultCityId = [[[NSUserDefaults standardUserDefaults] 
                                valueForKey:USER_DEFAULTS_CITY_ID] intValue];
    
    switch (requestType) {
        case kEVTURIEventByCity:
            cachedData = [[TTURLCache sharedCache] dataForKey:[NSString stringWithFormat:@"%@_%d", 
                                                               TT_CACHE_KEY_EVENT_BY_CITY, defaultCityId]
                                                      expires:TT_CACHE_DURATION_EVENT_BY_CITY 
                                                    timestamp:nil];
            break;
        case kEVTURIVenueByCity:
            cachedData = [[TTURLCache sharedCache] dataForKey:[NSString stringWithFormat:@"%@_%d", 
                                                               TT_CACHE_KEY_VENUE_BY_CITY, defaultCityId]
                                                      expires:TT_CACHE_DURATION_VENUE_BY_CITY 
                                                    timestamp:nil];
            break;
        default:
            break;
    }
    
    if ([cachedData length] > 0) {
        parsedData = [[NSString alloc] initWithData:cachedData encoding:NSUTF8StringEncoding];
        return [parsedData JSONValue];
    } else {
        return nil;
    }
}

/**
 * Responsible for making an async http request
 * of the given type with given parameters.
 */
- (BOOL)makeAsyncHttpRequest:(EVTWebserviceType)requestType 
                    delegate:(id)delegateObject
                 cachePolicy:(TTURLRequestCachePolicy)three20CachePolicy
                      params:(id)param, ... 
{
    // Declarations... (need to do this because of the switch)
    long serverTimeOffset = [[[NSUserDefaults standardUserDefaults] 
                              valueForKey:USER_DEFAULTS_TIME_DELTA] longValue];
    long adjustedTimestamp = [[NSDate date] timeIntervalSince1970] + serverTimeOffset;
    NSString *rawURI;
    NSString *processedURI;
    NSInteger defaultCityId = [[[NSUserDefaults standardUserDefaults] 
                                valueForKey:USER_DEFAULTS_CITY_ID] intValue];
    TTURLRequest *request;
    TTURLJSONResponse *response;
    
    // Variable argument array
    NSMutableArray *finalArguments = [NSMutableArray array];
    va_list args;
    va_start(args, param);
    for (id arg = param; arg != nil; arg = va_arg(args, id))
    {
        [finalArguments addObject:arg];
    }
    va_end(args);
    
    switch (requestType) {
        case kEVTURIVenueByCity:
            rawURI = [URI_WEBSERVICE stringByAppendingString:URI_VENUE_BY_CITY];
            processedURI = [rawURI stringByReplacingOccurrencesOfString:@":city_id:" 
                                                             withString:[NSString stringWithFormat:@"%d", 
                                                                         defaultCityId]];
            request = [TTURLRequest requestWithURL:processedURI delegate:delegateObject];
            request.cacheKey = [NSString stringWithFormat:@"%@_%d", TT_CACHE_KEY_VENUE_BY_CITY, 
                                defaultCityId];
            request.cacheExpirationAge = TT_CACHE_DURATION_VENUE_BY_CITY;
            break;
            
        case kEVTURIVenueByCountry:
            processedURI = [[URI_WEBSERVICE stringByAppendingString:URI_VENUE_BY_COUNTRY] 
                            stringByReplacingOccurrencesOfString:@":countryCode:" 
                            withString:EVT_COUNTRYCODE];
            request = [TTURLRequest requestWithURL:processedURI delegate:delegateObject];
            request.cacheKey = TT_CACHE_KEY_VENUE_BY_COUNTRY;
            request.cacheExpirationAge = TT_CACHE_DURATION_VENUE_BY_COUNTRY;
            break;
        case kEVTURIEventByCity:
            processedURI = [NSString stringWithFormat:@"%@%@", 
                            URI_WEBSERVICE,
                            [[URI_EVENT_BY_CITY
                              stringByReplacingOccurrencesOfString:@":city_id:" 
                              withString:[NSString stringWithFormat:@"%d", defaultCityId]] 
                             stringByReplacingOccurrencesOfString:@":timestamp_start:" 
                             withString:[NSString stringWithFormat:@"%lu", adjustedTimestamp]]];
            request = [TTURLRequest requestWithURL:processedURI delegate:delegateObject];
            request.cachePolicy = three20CachePolicy;
            request.cacheKey = [NSString stringWithFormat:@"%@_%d", TT_CACHE_KEY_EVENT_BY_CITY, 
                                defaultCityId];
            request.cacheExpirationAge = TT_CACHE_DURATION_EVENT_BY_CITY;
            break;
        case kEVTURIEventByVenue:
            processedURI = [NSString stringWithFormat:@"%@%@", 
                            URI_WEBSERVICE,
                            [[URI_EVENT_BY_VENUE
                              stringByReplacingOccurrencesOfString:@":venue_id:" 
                              withString:[NSString stringWithFormat:@"%d", 
                                          [[finalArguments objectAtIndex:0] intValue]]] 
                             stringByReplacingOccurrencesOfString:@":timestamp_start:" 
                             withString:[NSString stringWithFormat:@"%lu", adjustedTimestamp]]];
            request = [TTURLRequest requestWithURL:processedURI delegate:delegateObject];
            request.cachePolicy = three20CachePolicy;
            request.cacheKey = [NSString stringWithFormat:@"%@_%d", TT_CACHE_KEY_EVENT_BY_VENUE, 
                                [[finalArguments objectAtIndex:0] intValue]];
            request.cacheExpirationAge = TT_CACHE_DURATION_EVENT_BY_VENUE;
            break;
        case kEVTURICityByCountry:
            processedURI = [[URI_WEBSERVICE stringByAppendingString:URI_CITY_BY_COUNTRY] 
                            stringByReplacingOccurrencesOfString:@":countryCode:" 
                            withString:EVT_COUNTRYCODE];
            request = [TTURLRequest requestWithURL:processedURI delegate:delegateObject];
            request.cacheKey = TT_CACHE_KEY_CITY_BY_COUNTRY;
            request.cacheExpirationAge = TT_CACHE_DURATION_CITY_BY_COUNTRY;
            break;
        default:
            return NO;
    }
     
    // Rest of the request data.
    response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    request.cachePolicy = three20CachePolicy;
    request.headers = [[EVTEventsConfig sharedEventsConfig] httpHeaders];
    [request send];
    
    return YES;
}

#pragma mark - Memory management
 
- (void)dealloc
{
    [_sharedEventsConfig release];
    [super dealloc];
}

@end
