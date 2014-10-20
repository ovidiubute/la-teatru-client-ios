/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#define NOTIFICATION_DISPLAY_TAG 100

typedef enum {
  NotificationDisplayTypeText = 0,
  NotificationDisplayTypeLoading = 1
} NotificationDisplayType;

@interface IFNNotificationDisplay : UIView {
	UILabel *lblDisplay;
	UIActivityIndicatorView *activity;
	NotificationDisplayType type;
}

@property (nonatomic, assign) NotificationDisplayType type;

- (id) init;
- (void) setNotificationText:(NSString*) _text;
- (void) displayInView:(UIView*) _view 
              atCenter:(CGPoint) _center 
          withInterval:(float) _interval;
- (void) removeNotification;

@end
