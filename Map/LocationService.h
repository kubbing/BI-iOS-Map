//
//  LocationService.h
//  Map
//
//  Created by Jakub Hladík on 07.11.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationService : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

+ (LocationService *)sharedService;

- (void)startService;

@end
