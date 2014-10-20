/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import <MessageUI/MessageUI.h>

#import "EventSectionedDataSource.h"
#import "EVTBaseDetailsViewController.h"
#import "EVTEmailComposer.h"
#import "EVTFBFeedPost.h"

#import "IFNNotificationDisplay.h"

/*
 * EVTEventDetailsViewController
 *
 * Controller that manages the view displaying event info.
 * It also manages social sharing via: 
 * - e-mail
 * - Facebook
 *
 */
@interface EVTEventDetailsViewController : EVTBaseDetailsViewController <UIActionSheetDelegate, 
MFMailComposeViewControllerDelegate, EVTFBFeedPostDelegate> {
    NSInteger eventId;
}

@property (nonatomic) NSInteger eventId;

- (id)initWithId:(NSInteger)aVenueId;
- (void)openShareMenu;

@end