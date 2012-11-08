//
//  ViewController.m
//  Map
//
//  Created by Jakub Hladík on 07.11.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import "MapViewController.h"
#import "MyPOI.h"

@interface MapViewController ()

@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSMutableArray *placemarks;

@end

@implementation MapViewController

- (CLGeocoder *)geocoder
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _geocoder = [[CLGeocoder alloc] init];
    });
    
    return _geocoder;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationUpdatedNotification:)
                                                 name:@"locationUpdated"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:self.currentCoordinate
                                                               radius:10000
                                                           identifier:nil];
    DEFINE_BLOCK_SELF;
    [self.geocoder geocodeAddressString:searchBar.text
                               inRegion:region
                      completionHandler:^(NSArray *placemarks, NSError *error) {
                          [blockSelf addPlacemarks:placemarks];
                      }];
}

- (void)addPlacemarks:(NSArray *)placemarks
{
    for (CLPlacemark *place in placemarks) {
        MyPOI *poi = [[MyPOI alloc] init];
        poi.placemark = place;
        [poi setCoordinate:place.location.coordinate];
        [self.mapView addAnnotation:poi];
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    NSString *poiId = @"poiId";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:poiId];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:poiId];
        ((MKPinAnnotationView *)view).animatesDrop = YES;
        ((MKPinAnnotationView *)view).canShowCallout = YES;
    }
    
    view.annotation = annotation;
    
    return view;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D coordinate = mapView.region.center;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
    DEFINE_BLOCK_SELF;
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            [blockSelf setSearchBarTextWithPlacemark:[placemarks lastObject]];
                        }];
}

- (void)setSearchBarTextWithPlacemark:(CLPlacemark *)aPlacemark
{
    NSString *string = [NSString stringWithFormat:@"%@, %@", aPlacemark.name, aPlacemark.subLocality];
    self.searchBar.text = string;
}

#pragma mark - Actions

- (IBAction)centerButtonTapped:(id)sender
{
    MKCoordinateRegion region = MKCoordinateRegionMake(self.currentCoordinate,
                                                       MKCoordinateSpanMake(0.05, 0.05));
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - Notifications

- (void)locationUpdatedNotification:(NSNotification *)aNotification
{
//    TRC_OBJ(aNotification.userInfo);
    CLLocation *location = aNotification.userInfo[@"location"];
    self.currentCoordinate = location.coordinate;
}

@end
