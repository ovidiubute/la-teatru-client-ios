/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "GADBannerView.h"

@interface EVTBaseTableViewController : TTTableViewController <GADBannerViewDelegate> {
    GADBannerView *adBannerView;
}

@property (nonatomic, retain) GADBannerView *adBannerView;

@end
