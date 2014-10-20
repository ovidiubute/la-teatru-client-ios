/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EventDataModel.h"

@implementation EVTEventDataModel

#pragma mark - Instance variables

@synthesize items;
@synthesize venueId;

#pragma mark - Constructors

- (id)init
{
    self = [super init];
    if (self) {
        self.venueId = -1;
    }
    return self;
}

- (id)initWithVenueId:(NSInteger)aVenueId
{
    self = [super init];
    if (self) {
        self.venueId = aVenueId;
    }
    return self;
}

#pragma mark - TTURLRequestModel methods

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more 
{    
    if (!self.isLoading) {
        if (self.venueId == -1) {
            [[EVTEventsConfig sharedEventsConfig] makeAsyncHttpRequest:kEVTURIEventByCity 
                                                           delegate:self 
                                                        cachePolicy:cachePolicy 
                                                             params:nil];
        } else if (self.venueId > 0) {
            [[EVTEventsConfig sharedEventsConfig] makeAsyncHttpRequest:kEVTURIEventByVenue
                                                           delegate:self 
                                                        cachePolicy:cachePolicy 
                                                             params:[NSNumber numberWithInt:self.venueId],nil];
        }
        
        // Load Venues in cache if there're not present yet.
        if ([[EVTEventsConfig sharedEventsConfig] getCachedData:kEVTURIVenueByCity] == nil) {
            [[EVTEventsConfig sharedEventsConfig] makeAsyncHttpRequest:kEVTURIVenueByCity 
                                                           delegate:nil 
                                                        cachePolicy:cachePolicy 
                                                             params:nil];
        }
    }
}

#pragma mark - TTURLRequestDelegate methods

- (void)requestDidFinishLoad:(TTURLRequest *)request 
{    
    // Store the event objects
    NSMutableArray *eventItems = [[NSMutableArray alloc] init];
    
    // JSON response.
    TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (NSDictionary *eventDict in response.rootObject) {
        [eventItems addObject:[EVTEvent eventWithDictionary:eventDict]];
    }
    [pool drain];
    
    [self setItems:eventItems];
    TT_RELEASE_SAFELY(eventItems);
    
    [super requestDidFinishLoad:request];
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error 
{
    [super request:request didFailLoadWithError:error];
}

#pragma mark - TTTableViewDataSource methods

- (void)search:(NSString *)searchText
{
    if (searchText.length > 1) {
        NSMutableArray *updatedItems = [NSMutableArray array];
        
        NSArray *cachedResults;
        if (self.venueId == -1) {
            cachedResults = [[EVTEventsConfig sharedEventsConfig] getCachedData:(kEVTURIEventByCity)];
        } else {
            cachedResults = [[EVTEventsConfig sharedEventsConfig] getCachedData:(kEVTURIEventByVenue)];
        }
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        for (NSDictionary *dict in cachedResults) {
            EVTEvent *e = [EVTEvent eventWithDictionary:dict];
            NSRange result = [e.title rangeOfString:searchText 
                                            options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch 
                                              range:NSMakeRange(0, [e.title length])];
            if (result.location != NSNotFound) {
                [updatedItems addObject:e];
            }
        }
        [pool drain];
        
        self.items = updatedItems;
        [_delegates perform:@selector(modelDidChange:) withObject:self];
    }
}

- (void)dealloc
{
    TT_RELEASE_SAFELY(items);
    [super dealloc];
}

@end
