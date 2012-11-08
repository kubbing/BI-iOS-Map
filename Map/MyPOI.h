//
//  MyPOI.h
//  Map
//
//  Created by Jakub Hladík on 07.11.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyPOI : NSObject <MKAnnotation>

@property (nonatomic, strong) CLPlacemark *placemark;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
