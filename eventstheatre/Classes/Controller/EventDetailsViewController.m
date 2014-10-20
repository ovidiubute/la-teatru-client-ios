/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EventDetailsViewController.h"

@implementation EVTEventDetailsViewController

#pragma mark - Instance variables

@synthesize eventId;

#pragma mark - Constructor

- (id)initWithId:(NSInteger)anEventId {
    if (self = [super init]) {
        self.eventId = anEventId;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Detalii piesă",@"EventInfoTitle");
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self 
                                                                                 action:@selector(openShareMenu)];
    self.navigationItem.rightBarButtonItem = shareButton;
    [shareButton release];
}

#pragma mark - Public methods

- (void)openShareMenu
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Trimite unui prieten"
                                                       delegate:self 
                                              cancelButtonTitle:@"Anuleaza" 
                                         destructiveButtonTitle:nil 
                                              otherButtonTitles:@"Facebook", @"E-mail", nil];
    popup.actionSheetStyle = UIActionSheetStyleAutomatic;
    [popup showInView:self.view];
    [popup release];
}

#pragma mark -
#pragma mark EVTFBFeedPostDelegate

- (void) failedToPublishPost:(EVTFBFeedPost*) _post {
    
	UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
	
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Failed To Post"];
	[display displayInView:self.view 
                  atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
	[display release];
	
	[_post release];
}

- (void) finishedPublishingPost:(EVTFBFeedPost*) _post {
    
	UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
	
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Finished Posting"];
	[display displayInView:self.view 
                  atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
	[display release];
	
	[_post release];
}


#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError *)error
{
    switch (result)  
    {  
        case MFMailComposeResultCancelled:  
        {  
            break;  
        }  
        case MFMailComposeResultSaved:  
        {  
            break;  
        }  
        case MFMailComposeResultSent:  
        {   
            break;  
        }  
        case MFMailComposeResultFailed:  
        {  
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" 
                                                         message:@"Mesajul nu a putut fi trimis!" 
                                                        delegate:self 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil];  
            [alert show];  
            [alert release];  
            break;  
        }  
        default:  
        {  
            break;  
        }  
    }  
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetDelegate methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {        
        // We will release this object when it is finished posting
        EVTFBFeedPost *post = [[EVTFBFeedPost alloc] initWithPostMessage:@"Hai la teatru!"];
        [post publishPostWithDelegate:self];
        
        IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
        display.type = NotificationDisplayTypeLoading;
        display.tag = NOTIFICATION_DISPLAY_TAG;
        [display setNotificationText:@"Posting Status..."];
        [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:0.0];
        [display release];
    } else if (buttonIndex == 1) {
        EVTEmailComposer *composer = [[EVTEmailComposer alloc] init];
        [composer setSubject:@"Hai la teatru!"];
        [composer setMailComposeDelegate:self];
        [self.navigationController presentModalViewController:composer animated:YES];
        [composer release];
    }
}


#pragma mark - TTTableViewController methods

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    id userInfoObject = [[object userInfo] objectForKey:@"scheduleObject"];
    if (userInfoObject != nil && [userInfoObject isMemberOfClass:[EVTEventSchedule class]]) {
        TTURLAction *action =  [[[TTURLAction actionWithURLPath:@"tt://eknewevent"] 
                                 applyQuery:[object userInfo]]
                                 applyAnimated:YES];
        [[TTNavigator navigator] openURLAction:action];
    }
}

#pragma mark - TTModelViewController methods

- (void)createModel 
{
    EVTEventSectionedDataSource *eventDataSource = [[EVTEventSectionedDataSource alloc] 
                                                    initWithEventId:self.eventId];
    self.dataSource = eventDataSource;
    TT_RELEASE_SAFELY(eventDataSource);
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc 
{
    [super dealloc];
}

@end
