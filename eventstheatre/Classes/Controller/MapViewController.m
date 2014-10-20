/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "MapViewController.h"

@implementation EVTMapViewController

#pragma mark - Instance variables

@synthesize venueMapView;
@synthesize venueList;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_CITY_NAME],
                                   @"TitleVenueMap");
    
    // List of venues.
    venueList = [[NSMutableArray alloc] init];
    
    // Make the map view take up the entire screen.
    venueMapView = [[[EVTVenueMapView alloc] 
                     initWithFrame:CGRectMake(self.view.frame.origin.x, 
                                              self.view.frame.origin.y, 
                                              self.view.bounds.size.width, 
                                              self.view.bounds.size.height)] autorelease];
    
    venueMapView.delegate = self;
    [self.view addSubview:venueMapView];
    
    [[EVTEventsConfig sharedEventsConfig] makeAsyncHttpRequest:kEVTURIVenueByCity 
                                                      delegate:self 
                                                   cachePolicy:TTURLRequestCachePolicyDefault 
                                                        params:nil];
}

#pragma mark - MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *view = nil;
    view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"EVTAnnotationIdentifier"];
    if (!view) {
        view = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
                                                reuseIdentifier:@"EVTAnnotationIdentifier"] autorelease];
        view.canShowCallout = YES;
        
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        if ([annotation isKindOfClass:[EVTMapAnnotation class]]) {
            NSInteger venueId = (NSInteger)[annotation performSelector:@selector(venueId)];
            if (venueId > 0) {
                [infoButton setTag:venueId];
            }
        }
        
        view.rightCalloutAccessoryView = infoButton;
    }
    return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([control tag] != 0) {
        NSString *url = [NSString stringWithFormat:@"tt://venuedetails/%d",[control tag]];
        [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:url]];
    }
}

#pragma mark - TTURLRequestDelegate methods

- (void)requestDidFinishLoad:(TTURLRequest *)request 
{ 
    TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (NSDictionary *venueDict in response.rootObject) {
        EVTVenue *v = [EVTVenue venueWithDictionary:venueDict];
        [self.venueList addObject:v];
    }
    [pool drain];
    
    [self displayMap];
}

#pragma mark - Public methods

- (void)displayMap
{
    if ([self.venueList count] != 0) {
        NSInteger defaultCityId = [[[NSUserDefaults standardUserDefaults] 
                                    objectForKey:USER_DEFAULTS_CITY_ID] intValue];
        double defaultCityLat = [[[NSUserDefaults standardUserDefaults]
                                  objectForKey:USER_DEFAULTS_CITY_LAT] doubleValue];
        double defaultCityLng = [[[NSUserDefaults standardUserDefaults]
                                  objectForKey:USER_DEFAULTS_CITY_LNG] doubleValue];
        
        if (defaultCityLng == 0 || defaultCityLat == 0) {
            // On an update the user will restore his session and <maybe> will not have the
            // latitude longitude info available :(
            // So we use our static city list again (suppose it's a hack)
            NSError *stringErr = nil;
            NSString *jsonCityListPath = [[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"json"];
            NSString *jsonCityList = [NSString stringWithContentsOfFile:jsonCityListPath 
                                                               encoding:NSUTF8StringEncoding error:&stringErr];
            if (jsonCityList != nil && stringErr == nil) {
                NSArray *staticCityList = [jsonCityList JSONValue];
                if (staticCityList != nil) {
                    for (NSDictionary *cityDict in staticCityList) {
                        EVTCity *c = [EVTCity cityWithDictionary:cityDict];
                        if ([c cityId] == defaultCityId) {
                            defaultCityLat = [c lat];
                            defaultCityLng = [c lng];
                            break;
                        }
                    }
                }
            }
        }
        
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = defaultCityLat;
        zoomLocation.longitude = defaultCityLng;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 6000, 6000);
        MKCoordinateRegion adjustedRegion = [venueMapView regionThatFits:viewRegion];                        
        [venueMapView setRegion:adjustedRegion animated:NO];  

        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        for (EVTVenue *v in venueList) {
            if (v.lat != 0 && v.lng != 0 && v.cityId == defaultCityId) {
                CLLocationCoordinate2D venueLocation;
                venueLocation.latitude = v.lat;
                venueLocation.longitude = v.lng;
                EVTMapAnnotation * annotation = [[[EVTMapAnnotation alloc] initWithCoordinate:venueLocation
                                                                                        title:v.name
                                                                                     subtitle:v.address
                                                                                      venueId:v.venueId] 
                                                 autorelease];
                [venueMapView addAnnotation:annotation];
            }
        }
        [pool drain];
    }
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
    TT_RELEASE_SAFELY(venueList);
    [super dealloc];
}

@end
