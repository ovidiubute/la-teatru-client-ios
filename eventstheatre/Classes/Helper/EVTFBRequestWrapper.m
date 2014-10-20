/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EVTFBRequestWrapper.h"

static EVTFBRequestWrapper *defaultWrapper = nil;

@implementation EVTFBRequestWrapper

@synthesize isLoggedIn;

+ (id) defaultManager {
	
	if (!defaultWrapper)
		defaultWrapper = [[EVTFBRequestWrapper alloc] init];
	
	return defaultWrapper;
}

- (void) setIsLoggedIn:(BOOL) _loggedIn {
	isLoggedIn = _loggedIn;
	
	if (isLoggedIn) {
		[[NSUserDefaults standardUserDefaults] setObject:facebook.accessToken forKey:@"fb_access_token"];
		[[NSUserDefaults standardUserDefaults] setObject:facebook.expirationDate forKey:@"fb_exp_date"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else {
		[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fb_access_token"];
		[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fb_exp_date"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void) FBSessionBegin:(id<FBSessionDelegate>) _delegate {
	
	if (facebook == nil) {
		facebook = [[Facebook alloc] initWithAppId:FB_APP_ID andDelegate:self];
		
		NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"fb_access_token"];
		NSDate *exp = [[NSUserDefaults standardUserDefaults] objectForKey:@"fb_exp_date"];
		
		if (token != nil && exp != nil && [token length] > 2) {
			isLoggedIn = YES;
			facebook.accessToken = token;
            facebook.expirationDate = [NSDate distantFuture];
		} 
		
		
		[facebook retain];
	}
	
	NSArray * permissions = [NSArray arrayWithObjects:
							 @"publish_stream",
							 nil];
	
	// If no session is available login
	[facebook authorize:permissions];
}

- (void) FBLogout {
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fb_access_token"];
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fb_exp_date"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[facebook logout];
}

// Make simple requests
- (void) getFBRequestWithGraphPath:(NSString*) _path andDelegate:(id) _delegate {
	if (_path != nil) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		
		if (_delegate == nil)
			_delegate = self;
		
		[facebook requestWithGraphPath:_path andDelegate:_delegate];
	}
}

// Used for publishing
- (void) sendFBRequestWithGraphPath:(NSString*) _path params:(NSMutableDictionary*) _params andDelegate:(id) _delegate {
	
	if (_delegate == nil)
		_delegate = self;
	
	if (_params != nil && _path != nil) {
		
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		[facebook requestWithGraphPath:_path andParams:_params andHttpMethod:@"POST" andDelegate:_delegate];
	}
}

#pragma mark -
#pragma mark FacebookSessionDelegate

- (void)fbDidLogin {
	isLoggedIn = YES;
	
	[[NSUserDefaults standardUserDefaults] setObject:facebook.accessToken forKey:@"fb_access_token"];
	[[NSUserDefaults standardUserDefaults] setObject:facebook.expirationDate forKey:@"fb_exp_date"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
	isLoggedIn = NO;
}

- (void)fbDidLogout {
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fb_access_token"];
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fb_exp_date"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	isLoggedIn = NO;
}


#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void) dealloc {
	[facebook release], facebook = nil;
	[super dealloc];
}

@end
