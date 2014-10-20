/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "Base.h"

/*
 * EVTEvent
 *
 * An immutable value object that represents a single element
 * in the dataset.
 */
@interface EVTEvent : EVTBase {
    /**
     * Basic info.
     */
    NSInteger eventId;
    NSInteger venueId;
    NSString *title;
    
    /**
     * Text BLOBs with detailed info.
     */
    NSString *detailsStory;
    NSString *detailsTechnical;
    NSString *detailsCast;
    
    /** 
     * Misc. info.
     */
    NSString *author;
    NSString *ticketPrice;
    NSString *hall;
    
    /**
     * List of NSString dates.
     */
    NSArray  *scheduleList;
}

@property (nonatomic, readonly)         NSInteger eventId;
@property (nonatomic, readonly)         NSInteger venueId;
@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain, readonly) NSString *detailsStory;
@property (nonatomic, retain, readonly) NSString *detailsTechnical;
@property (nonatomic, retain, readonly) NSString *detailsCast;
@property (nonatomic, retain, readonly) NSString *author;
@property (nonatomic, retain, readonly) NSString *ticketPrice;
@property (nonatomic, retain, readonly) NSString *hall;
@property (nonatomic, retain, readonly) NSArray  *scheduleList;

+ (EVTEvent*)eventWithDictionary:(NSDictionary *)dictionary;
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
- (id)initWithId:(NSInteger)anEventId 
         venueId:(NSInteger)aVenueId 
           title:(NSString *)aTitle 
    detailsStory:(NSString *)aDetailsStory 
detailsTechnical:(NSString *)aDetailsTechnical
     detailsCast:(NSString *)aDetailsCast 
          author:(NSString *)anAuthor 
     ticketPrice:(NSString *)aTicketPrice 
            hall:(NSString *)aHall 
    scheduleList:(NSMutableArray *)aScheduleList;

@end
