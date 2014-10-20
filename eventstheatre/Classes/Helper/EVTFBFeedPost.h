/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EVTFBRequestWrapper.h"

@protocol EVTFBFeedPostDelegate;

typedef enum {
    FBPostTypeStatus = 0,
    FBPostTypePhoto = 1,
    FBPostTypeLink = 2
} FBPostType;

@interface EVTFBFeedPost : NSObject <FBRequestDelegate, FBSessionDelegate>
{
	NSString *url;
	NSString *message;
	NSString *caption;
	UIImage *image;
	FBPostType postType;
    
	id <EVTFBFeedPostDelegate> delegate;
}

@property (nonatomic, assign) FBPostType postType;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) UIImage *image;

@property (nonatomic, assign) id <EVTFBFeedPostDelegate> delegate;

- (id) initWithLinkPath:(NSString*) _url caption:(NSString*) _caption;
- (id) initWithPostMessage:(NSString*) _message;
- (id) initWithPhoto:(UIImage*) _image name:(NSString*) _name;
- (void) publishPostWithDelegate:(id) _delegate;

@end

@protocol EVTFBFeedPostDelegate
@required
- (void) failedToPublishPost:(EVTFBFeedPost*) _post;
- (void) finishedPublishingPost:(EVTFBFeedPost*) _post;
@end