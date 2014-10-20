/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "eventstheatreAppDelegate.h"

@implementation EVTEventsTheatreAppDelegate

#pragma mark - Instance variables

@synthesize window = _window;

#pragma mark - UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    // Configure Apple push notifications using UrbanAirship lib.
    [self configureNotifications];
    
    // Global Three20 stylesheet.
    [TTStyleSheet setGlobalStyleSheet:[[[EVTStyleSheet alloc] init] autorelease]];
    
    // Black iPhone status bar.
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    // UIWindow init.
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window makeKeyAndVisible];
    
    // Map of Three20 URLs.
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    TTURLMap* map = navigator.URLMap;
    [map from:@"*"                               toViewController:[TTWebController class]];
    [map from:@"tt://launcher/"                  toViewController:[EVTLauncherViewController class]];
    [map from:@"tt://calendar/"                  toViewController:[EVTCalendarViewController class]];
    [map from:@"tt://venue/"                     toViewController:[EVTVenuesViewController class]];
    [map from:@"tt://event/"                     toViewController:[EVTEventsViewController class]];
    [map from:@"tt://event/(initWithVenueId:)"   toViewController:[EVTEventsViewController class]];
    [map from:@"tt://eventdetails/(initWithId:)" toViewController:[EVTEventDetailsViewController class]];
    [map from:@"tt://maps/"                      toViewController:[EVTMapViewController class]];
    [map from:@"tt://venuedetails/(initWithId:)" toViewController:[EVTVenueDetailsViewController class]];
    [map from:@"tt://eknewevent"                 toModalViewController:[EVTCalendarEventViewController class]];
    
    // Launch dashboard OR restore from history
    if (![navigator restoreViewControllers]) {
        [navigator openURLAction:
         [TTURLAction actionWithURLPath:@"tt://launcher"]];
    }
    
    // Save the current UTC offset to NSUserDefaults.
    // We are making the assumption that the server will always run in UTC timezone.
    long currentGMTOffset = [[NSTimeZone localTimeZone] secondsFromGMT];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithLong:currentGMTOffset] 
                                             forKey:USER_DEFAULTS_TIME_DELTA];
        
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {    
    [[UAPush shared] handleNotification:userInfo applicationState:application.applicationState];
    [[UAPush shared] resetBadge]; // zero badge after push received
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA
    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
    [UAirship land];
}

#pragma mark - Public methods

- (void)configureNotifications
{
    // Init Airship launch options.
    NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
    NSMutableDictionary *airshipConfigOptions = [[[NSMutableDictionary alloc] init] autorelease];
    [airshipConfigOptions setValue:EVT_NOTIFICATIONS_DEV_APP_KEY forKey:@"DEVELOPMENT_APP_KEY"];
    [airshipConfigOptions setValue:EVT_NOTIFICATIONS_DEV_APP_SECRET forKey:@"DEVELOPMENT_APP_SECRET"];
    [airshipConfigOptions setValue:EVT_NOTIFICATIONS_PROD_APP_KEY forKey:@"PRODUCTION_APP_KEY"];
    [airshipConfigOptions setValue:EVT_NOTIFICATIONS_PROD_APP_SECRET forKey:@"PRODUCTION_APP_SECRET"];    
    [airshipConfigOptions setValue:EVT_NOTIFICATIONS_GATEWAY_PROD forKey:@"APP_STORE_OR_AD_HOC_BUILD"];
    
    // Create Airship singleton that's used to talk to Urban Airship servers.
    [takeOffOptions setValue:airshipConfigOptions forKey:UAirshipTakeOffOptionsAirshipConfigKey];
    [UAirship takeOff:takeOffOptions];
    
    [[UAPush shared] enableAutobadge:YES];
    [[UAPush shared] resetBadge];//zero badge on startup
    
    // Register for notifications through UAPush for notification type tracking
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeSound |
                                                         UIRemoteNotificationTypeAlert)];
}

#pragma mark - Memory management

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
