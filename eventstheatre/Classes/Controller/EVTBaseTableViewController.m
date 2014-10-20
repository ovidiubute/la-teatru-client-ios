/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EVTBaseTableViewController.h"

@implementation EVTBaseTableViewController

#pragma mark - Instance variables

@synthesize adBannerView = _adBannerView;

#pragma mark - Constructor

- (id)init 
{
    if (self = [super init]) {
        self.variableHeightRows = YES;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    // AdMob banner view.
    _adBannerView = [[GADBannerView alloc]
                     initWithFrame:CGRectMake(0.0,
                                              self.view.frame.size.height -
                                              GAD_SIZE_320x50.height,
                                              GAD_SIZE_320x50.width,
                                              GAD_SIZE_320x50.height)];
    _adBannerView.delegate = self;
    _adBannerView.adUnitID = ADMOB_AD_UNIT_ID;
    _adBannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    [request setTestDevices:[NSArray arrayWithObjects:
                             GAD_SIMULATOR_ID                             // Simulator
                             @"e7c7c9377864ee78a32d01b258dddf5b99e995c7", // iPhone 4
                             @"19f2f3de66d0c9660de6851a79f5e3adeb924ee5", // iPhone 3GS
                             nil]];
    [request setLocationWithDescription:@"Romania"];
    [_adBannerView loadRequest:request];
    [self.view addSubview:_adBannerView];
}

#pragma mark - GADBannerViewDelegate methods

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    // Animate and display ad banner.
    [UIView beginAnimations:@"BannerSlide" context:nil];
    // We add 2 pixels because it seems AdMob banners are not respecting the default resolution.
    _adBannerView.frame = CGRectMake(0.0,
                                     self.view.frame.size.height -
                                     _adBannerView.frame.size.height + 2,
                                     _adBannerView.frame.size.width,
                                     _adBannerView.frame.size.height);
    self.tableView.frame = CGRectMake(self.view.bounds.origin.x,
                                      self.view.bounds.origin.y, 
                                      self.view.bounds.size.width, 
                                      self.view.bounds.size.height - GAD_SIZE_320x50.height + 2);
    [UIView commitAnimations];
}

#pragma mark - TTTableViewController methods

- (id<UITableViewDelegate>)createDelegate
{
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
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
    _adBannerView.delegate = nil;
    [_adBannerView release];
    [super dealloc];
}

@end
