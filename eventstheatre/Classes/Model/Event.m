/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */
#import "Event.h"

@implementation EVTEvent

#pragma mark - Instance variables

@synthesize eventId, venueId, title;
@synthesize detailsStory, detailsTechnical, detailsCast;
@synthesize author, ticketPrice, hall;
@synthesize scheduleList;

#pragma mark - Constructors

+ (EVTEvent*)eventWithDictionary:(NSDictionary *)dictionary
{
    return [[[self alloc] initWithId:[[dictionary objectForKey:@"id"] intValue] 
                             venueId:[[dictionary objectForKey:@"venueId"] intValue]
                               title:[dictionary  objectForKey:@"title"]
                        detailsStory:[dictionary  objectForKey:@"detailsStory"]
                    detailsTechnical:[dictionary  objectForKey:@"detailsTechnical"]
                         detailsCast:[dictionary  objectForKey:@"detailsCast"]
                              author:[dictionary  objectForKey:@"author"]
                         ticketPrice:[dictionary  objectForKey:@"ticketPrice"]
                                hall:[dictionary  objectForKey:@"hall"]
                        scheduleList:[dictionary  objectForKey:@"scheduleList"]] autorelease];
}

+ (EVTEvent*)eventWithId:(NSInteger)anEventId 
              venueId:(NSInteger)aVenueId 
                title:(NSString *)aTitle 
         detailsStory:(NSString *)aDetailsStory 
     detailsTechnical:(NSString *)aDetailsTechnical
          detailsCast:(NSString *)aDetailsCast 
               author:(NSString *)anAuthor 
          ticketPrice:(NSString *)aTicketPrice 
                 hall:(NSString *)aHall 
         scheduleList:(NSMutableArray *)aScheduleList;
{
    return [[[self alloc] initWithId:(NSInteger)anEventId 
                             venueId:(NSInteger)aVenueId 
                               title:(NSString *)aTitle 
                        detailsStory:(NSString *)aDetailsStory 
                    detailsTechnical:(NSString *)aDetailsTechnical 
                         detailsCast:(NSString *)aDetailsCast 
                              author:(NSString *)anAuthor 
                         ticketPrice:(NSString *)aTicketPrice 
                                hall:(NSString *)aHall 
                        scheduleList:(NSMutableArray *)aScheduleList] autorelease];
}

- (id)initWithId:(NSInteger)anEventId 
         venueId:(NSInteger)aVenueId 
           title:(NSString *)aTitle 
    detailsStory:(NSString *)aDetailsStory 
detailsTechnical:(NSString *)aDetailsTechnical
     detailsCast:(NSString *)aDetailsCast 
          author:(NSString *)anAuthor 
     ticketPrice:(NSString *)aTicketPrice 
            hall:(NSString *)aHall 
    scheduleList:(NSMutableArray *)aScheduleList
{
    if ((self = [super init])) {
        eventId          = anEventId;
        venueId          = aVenueId;
        title            = [aTitle copy];
        detailsStory     = [aDetailsStory copy];
        detailsTechnical = [aDetailsTechnical copy];
        detailsCast      = [aDetailsCast copy];
        author           = [anAuthor copy];
        ticketPrice      = [aTicketPrice copy];
        hall             = [aHall copy];
        scheduleList     = [aScheduleList copy];
    }
    return self;
}

#pragma mark - Memory management

- (void)dealloc
{
    [title release];
    [detailsStory release];
    [detailsTechnical release];
    [detailsCast release];
    [author release];
    [ticketPrice release];
    [hall release];
    [scheduleList release];
    [super dealloc];
}

@end
