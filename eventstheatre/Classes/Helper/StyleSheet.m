/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "StyleSheet.h"

@implementation EVTStyleSheet

#pragma mark - Public methods

/** 
 * Style for TTLauncherItems.
 */
- (TTStyle*)launcherButton:(UIControlState)state {
    return 
    [TTPartStyle styleWithName: @"image" 
                         style: TTSTYLESTATE(launcherButtonImage:, state) 
                          next: [TTTextStyle 
                                 styleWithFont:[UIFont boldSystemFontOfSize:12]
                                 color: RGBCOLOR(0, 0, 0)
                                 minimumFontSize: 11 
                                 shadowColor: nil
                                 shadowOffset: CGSizeZero 
                                 next: nil]];
}

/**
 * Override dashboard dot colors.
 */
- (TTStyle*)pageDot:(UIControlState)state {
    if (state == UIControlStateSelected) {
        return [self pageDotWithColor:RGBCOLOR(119, 140, 168)];
        
    } else {
        return [self pageDotWithColor:RGBCOLOR(77, 77, 77)];
    }
}

/**
 * Override the default banner height for tables.
 */
- (CGFloat)tableBannerViewHeight {
    return GAD_SIZE_320x50.height;
}

/**
 * Override default table font.
 */
- (UIFont*)tableFont {
    return [UIFont boldSystemFontOfSize:15];
}

@end
