/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "Facebook.h"

@interface EVTFBRequestWrapper : NSObject <FBRequestDelegate, FBSessionDelegate>
{
	Facebook *facebook;
	BOOL isLoggedIn;
}

@property (nonatomic, assign) BOOL isLoggedIn;

+ (id) defaultManager;
- (void) setIsLoggedIn:(BOOL) _loggedIn;
- (void) FBSessionBegin:(id<FBSessionDelegate>) _delegate;
- (void) FBLogout;
- (void) getFBRequestWithGraphPath:(NSString*) _path andDelegate:(id) _delegate;
- (void) sendFBRequestWithGraphPath:(NSString*) _path params:(NSMutableDictionary*) _params andDelegate:(id) _delegate;

@end