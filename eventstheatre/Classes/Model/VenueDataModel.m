/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "VenueDataModel.h"

@implementation EVTVenueDataModel

#pragma mark - Instance variables

@synthesize items;

#pragma mark - TTURLRequestModel methods

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more 
{
    if (!self.isLoading) {
        [[EVTEventsConfig sharedEventsConfig] makeAsyncHttpRequest:kEVTURIVenueByCity 
                                                       delegate:self 
                                                    cachePolicy:cachePolicy 
                                                         params:nil];
    }
}
    
#pragma mark - TTURLRequestDelegate methods

- (void)requestDidFinishLoad:(TTURLRequest *)request 
{    
    // Store the venue objects.
    NSMutableArray *venueItems = [[NSMutableArray alloc] init];

    // JSON response.
    TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (NSDictionary *dict in response.rootObject) {
        [venueItems addObject:[EVTVenue venueWithDictionary:dict]];
    }
    [pool drain];
    
    [self setItems:venueItems];
    TT_RELEASE_SAFELY(venueItems);
    
    [super requestDidFinishLoad:request];
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error 
{
    [super request:request didFailLoadWithError:error];
}

#pragma mark - TTTableViewDataSource methods

- (void)search:(NSString *)searchText
{
    if (searchText.length) {
        NSMutableArray *updatedItems = [NSMutableArray array];
        
        NSArray *cachedResults = [[EVTEventsConfig sharedEventsConfig] getCachedData:(kEVTURIVenueByCity)];
        for (NSDictionary *dict in cachedResults) {
            EVTVenue *v = [EVTVenue venueWithDictionary:dict];
            NSRange result = [v.name rangeOfString:searchText options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch range:NSMakeRange(0, [v.name length])];
            if (result.location != NSNotFound) {
                [updatedItems addObject:v];
            }
        }
        
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
