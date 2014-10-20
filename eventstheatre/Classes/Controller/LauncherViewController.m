/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "LauncherViewController.h"

@implementation EVTLauncherViewController

#pragma mark - Instance variables

@synthesize bannerView = _bannerView;
@synthesize cityList;
@synthesize cityPickerButton;
@synthesize cityPickerView;
@synthesize isModalVisible;
@synthesize launcherView;
@synthesize modalView;
@synthesize urlToOpen = _urlToOpen;

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    if (isModalVisible) {
        self.navigationItem.title = NSLocalizedString(@"Alegeți orașul", @"LauncherCityPickTitle");
    } else {
        self.navigationItem.title = NSLocalizedString(@"La Teatru", @"LauncherMainTitle");
    }
    
    // Setup modal view.
    modalView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    modalView.opaque = NO;
    modalView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    
    // Setup UIPickerView.
    cityPickerView = [[UIPickerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    cityPickerView.delegate = self;
    cityPickerView.dataSource = self;
    
    // City picker left nav button.
    NSString *defaultCityName = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULTS_CITY_NAME];
    if (defaultCityName == nil) {
        defaultCityName = NSLocalizedString(@"Orașe", @"CityPickerButton");
    }
    cityPickerButton = [[UIBarButtonItem alloc]
                        initWithTitle:defaultCityName
                        style:UIBarButtonItemStylePlain
                        target:self action:@selector(displayCitySelect)];
    self.navigationItem.leftBarButtonItem = cityPickerButton;
    
    // Dashboard view.
    CGRect customBounds = CGRectMake(self.view.bounds.origin.x,
                                     self.view.bounds.origin.y, 
                                     self.view.bounds.size.width, 
                                     self.view.bounds.size.height - GAD_SIZE_320x50.height);
    launcherView = [[TTLauncherView alloc]
                                    initWithFrame:customBounds];
    [launcherView setDelegate:self];
    launcherView.columnCount = 2;
    
    // Try to load dashboard items from user defaults or recreate them.
    NSData *dashboardData = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_DASHBOARD_PAGES];
    NSArray *dashboardPages = [NSKeyedUnarchiver unarchiveObjectWithData:dashboardData];
    if (dashboardPages == nil || [dashboardPages count] == 0) {
        launcherView.pages = [NSArray arrayWithObjects:
                              [NSArray arrayWithObjects:
                               [self launcherItemWithTitle:NSLocalizedString(@"Teatre", @"LauncherItemTheatres")
                                                     image:@"bundle://launcher-item-venues.png"
                                                       URL:@"tt://venue/"],
                               [self launcherItemWithTitle:NSLocalizedString(@"Spectacole", @"LauncherItemEvents")
                                                     image:@"bundle://launcher-item-events.png"
                                                       URL:@"tt://event/"],
                               [self launcherItemWithTitle:NSLocalizedString(@"Harta teatrelor", @"LauncherItemMap")
                                                     image:@"bundle://launcher-item-map.png"
                                                       URL:@"tt://maps/"],
                               [self launcherItemWithTitle:NSLocalizedString(@"Calendar", @"LauncherItemCalendar")
                                                     image:@"bundle://launcher-item-calendar.png"
                                                       URL:@"tt://calendar/"]
                               , nil]
                              , nil];
    } else {
        launcherView.pages = dashboardPages;
    }
    // Add dashboard to view hierarchy.
    [self.view addSubview:launcherView];
    
    // AdMob banner view.
    _bannerView = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            self.view.frame.size.height -
                                            GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    _bannerView.delegate = self;
    _bannerView.adUnitID = ADMOB_AD_UNIT_ID;
    _bannerView.rootViewController = self;
    GADRequest *adRequest = [GADRequest request];
    [adRequest setLocationWithDescription:@"Romania"];
    [_bannerView loadRequest:adRequest];
    [self.view addSubview:_bannerView];
    
    cityList = [[NSMutableArray alloc] init];
    // Request city list -- either from server(cache) OR from static file if this is first run
    BOOL cityListRetrievalError = NO;
    NSNumber *haveAlreadyUsedStaticFile = [[NSUserDefaults standardUserDefaults] 
                                           objectForKey:USER_DEFAULTS_USED_STATIC_CITY_LIST];
    
    if (haveAlreadyUsedStaticFile == nil) {
        NSError *stringErr;
        NSString *jsonCityListPath = [[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"json"];
        NSString *jsonCityList = [NSString stringWithContentsOfFile:jsonCityListPath 
                                                           encoding:NSUTF8StringEncoding error:&stringErr];
        if (jsonCityList == nil) {
            // Failed to read file..bail!
            cityListRetrievalError = YES;
        } else {
            NSArray *staticCityList = [jsonCityList JSONValue];
            if (staticCityList != nil) {
                for (NSDictionary *cityDict in staticCityList) {
                    EVTCity *c = [EVTCity cityWithDictionary:cityDict];
                    [self.cityList addObject:c];
                }
                
                // If this is the first application run, make the user select a city
                if ([[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULTS_CITY_NAME] == nil) {
                    [self performSelector:@selector(displayCitySelect)];
                }
                
                // MAKE SURE WE NEVER USE THIS FILE AGAIN!
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:
                 USER_DEFAULTS_USED_STATIC_CITY_LIST];
            } else {
                // Maybe we forgot the file in the bundle? Just bail!
                cityListRetrievalError = YES;
            }
        }
    } 
    
    // Failed to get city list from static file OR we have already used it..
    if ([haveAlreadyUsedStaticFile isEqual:[NSNumber numberWithBool:YES]] || cityListRetrievalError) {
        [[EVTEventsConfig sharedEventsConfig] makeAsyncHttpRequest:kEVTURICityByCountry 
                                                          delegate:self
                                                       cachePolicy:TTURLRequestCachePolicyDefault 
                                                            params:nil];
    }
}

#pragma mark - GADBannerViewDelegate methods

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    if (isModalVisible == NO) {
        // Animate and display ad banner.
        [UIView beginAnimations:@"BannerSlide" context:nil];
        _bannerView.frame = CGRectMake(0.0,
                                       self.view.frame.size.height -
                                       _bannerView.frame.size.height + 2,
                                       _bannerView.frame.size.width,
                                       _bannerView.frame.size.height);
        [UIView commitAnimations];
    }
}

#pragma mark - TTURLRequestDelegate methods

- (void)requestDidFinishLoad:(TTURLRequest *)request {    
    TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
    
    for (NSDictionary *cityDict in response.rootObject) {
        EVTCity *c = [EVTCity cityWithDictionary:cityDict];
        [self.cityList addObject:c];
    }
    
    // If this is the first application run, make the user select a city
    if ([[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULTS_CITY_NAME] == nil) {
        [self performSelector:@selector(displayCitySelect)];
    }
}

#pragma mark - Public methods

- (void)displayCitySelect 
{
    if (isModalVisible == NO && [cityList count] > 0) {
        // Display it (animated).
        [self.view addSubview:modalView];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        cityPickerView.frame = CGRectMake(0, 60, self.view.bounds.size.width, 216);
        cityPickerView.showsSelectionIndicator = YES;
        [modalView addSubview:cityPickerView];
        [UIView commitAnimations];
        
        // Scroll to the currently selected city (if any)
        NSString *defaultCityName = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULTS_CITY_NAME];
        if (defaultCityName != nil) {
            int cityIndex = -1;
            int i = 0;
            for (EVTCity *c in cityList) {
                if ([c.name isEqualToString:defaultCityName] == YES) {
                    cityIndex = i;
                    break;
                }
                i++;
            }
            if (cityIndex != -1) {
                [cityPickerView selectRow:cityIndex inComponent:0 animated:YES];
            }
        }
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                       target:self action:@selector(endCitySelect)];
        self.navigationItem.leftBarButtonItem = doneButton;
        [doneButton release];
        isModalVisible = YES;
    }
}

- (void)endCitySelect
{
    // Save the selection
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger rowIndex = [cityPickerView selectedRowInComponent:0];
    EVTCity *city = [cityList objectAtIndex:rowIndex];
    [defaults setObject:[NSNumber numberWithInt:city.cityId] forKey:USER_DEFAULTS_CITY_ID];
    [defaults setObject:city.name forKey:USER_DEFAULTS_CITY_NAME];
    [defaults setObject:[NSNumber numberWithDouble:city.lat] forKey:USER_DEFAULTS_CITY_LAT];
    [defaults setObject:[NSNumber numberWithDouble:city.lng] forKey:USER_DEFAULTS_CITY_LNG];
    
    // Hide modal view & picker.
    [modalView removeFromSuperview];
    
    // Prevent other stuff.
    isModalVisible = NO;
    
    // Set title we just chose.
    self.cityPickerButton.title = city.name;
    
    // Finally, show the picker button.
    self.navigationItem.leftBarButtonItem = cityPickerButton;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [cityList count];
}

#pragma mark - UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    EVTCity *c = [cityList objectAtIndex:row];
    return [c name];
}

#pragma mark - TTLauncherViewDelegate methods

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item 
{
    
    _urlToOpen = [NSString stringWithString:item.URL];
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:_urlToOpen] applyAnimated:YES]];
}

- (TTLauncherItem *)launcherItemWithTitle:(NSString *)pTitle
                                    image:(NSString *)image URL:(NSString *)url 
{
    TTLauncherItem *launcherItem = [[TTLauncherItem alloc]
                                    initWithTitle:pTitle
                                    image:image
                                    URL:url 
                                    canDelete:NO];
    return [launcherItem autorelease];
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher 
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:launcherView action:@selector(endEditing)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher 
{
    self.navigationItem.rightBarButtonItem = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:launcherView.pages];
    [defaults setObject:data forKey:USER_DEFAULTS_DASHBOARD_PAGES];
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
    [launcherView release];
    [modalView release];
    [cityPickerButton release];
    [cityPickerView release];
    _bannerView.delegate = nil;
    [_bannerView release];
    [cityList release];
    [super dealloc];
}

@end
