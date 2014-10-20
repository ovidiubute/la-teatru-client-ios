/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "City.h"
#import "GADBannerView.h"

/*
 * EVTLauncherViewController
 *
 * Controller that manages the dashboard.
 *
 */
@interface EVTLauncherViewController : TTViewController
<TTLauncherViewDelegate,TTURLRequestDelegate,GADBannerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource> {
    GADBannerView *bannerView;
    NSMutableArray *cityList;
    BOOL isModalVisible;
    UIBarButtonItem *cityPickerButton;
    UIPickerView *cityPickerView;
    TTLauncherView *launcherView;
    UIView *modalView;
    NSString *urlToOpen;
}

@property (nonatomic, retain) GADBannerView *bannerView;
@property (nonatomic, retain) NSMutableArray *cityList;
@property (nonatomic, assign) BOOL isModalVisible;
@property (nonatomic, retain) UIBarButtonItem *cityPickerButton;
@property (nonatomic, retain) UIPickerView *cityPickerView;
@property (nonatomic, retain) TTLauncherView *launcherView;
@property (nonatomic, retain) UIView *modalView;
@property (nonatomic, retain) NSString *urlToOpen;

- (void)displayCitySelect;
- (TTLauncherItem *)launcherItemWithTitle:(NSString *)pTitle image:(NSString *)image URL:(NSString *)url;

@end
