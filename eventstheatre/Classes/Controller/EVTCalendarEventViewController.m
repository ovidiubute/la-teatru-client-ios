/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EVTCalendarEventViewController.h"

@implementation EVTCalendarEventViewController

#pragma mark - Constructor

- (id) initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query 
{
    if (self = [super init]) {
        self.eventStore = [[[EKEventStore alloc] init] autorelease];
        self.editViewDelegate = self;
        self.event = [EKEvent eventWithEventStore:self.eventStore];
        
        EVTEventSchedule *anEventSchedule = [query objectForKey:@"scheduleObject"];
        if (anEventSchedule != nil) {
            self.event.startDate = [anEventSchedule date];
            // Hardcoded to 3 hours because we do not have event duration information.
            self.event.endDate = [[anEventSchedule date] dateByAddingTimeInterval:10800];
            self.event.title = [anEventSchedule.parentEvent title];
            if ([query objectForKey:@"venueName"] != nil) {
                // We also have the venue name!
                self.event.location = [query objectForKey:@"venueName"];
            }
        }
    }
    return self;
}

#pragma mark - EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action 
{
    NSError *error = nil;
    EKEvent *thisEvent = controller.event;
    
    switch (action) {
        case EKEventEditViewActionCanceled:
            // Edit action canceled, do nothing. 
            break;
            
        case EKEventEditViewActionSaved:            
            ;NSPredicate *calPredicate = [self.eventStore 
                                          predicateForEventsWithStartDate:thisEvent.startDate 
                                          endDate:thisEvent.endDate 
                                          calendars:[controller.eventStore calendars]];
            
            // Do not add the event twice...
            NSArray *events = [controller.eventStore eventsMatchingPredicate:calPredicate];
            BOOL foundEvent = NO;
            for (EKEvent *calendarEvent in events) {
                if ([calendarEvent.title isEqualToString:thisEvent.title] &&
                    [calendarEvent.location isEqualToString:thisEvent.location]) {
                    foundEvent = YES;
                    break;
                }
            }
            if (!foundEvent) {
                [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            }
            break;
            
        case EKEventEditViewActionDeleted:
            // When deleting an event, remove the event from the event store, 
            
            [self.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
            break;
            
        default:
            break;
    }
    
    [[[TTNavigator navigator] rootViewController] dismissModalViewControllerAnimated:YES];
}

#pragma mark - Memory management

- (void)dealloc 
{
    [super dealloc];
}

@end
