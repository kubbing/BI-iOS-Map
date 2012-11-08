//
//  LocationService.m
//  Map
//
//  Created by Jakub Hladík on 07.11.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import "LocationService.h"

@implementation LocationService

+ (LocationService *)sharedService
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (CLLocationManager *)locationManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    });
    
    return _locationManager;
}

- (void)startService
{
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdated"
                                                        object:nil
                                                      userInfo:@{ @"location" : location }];;
}

@end
