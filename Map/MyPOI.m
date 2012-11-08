//
//  MyPOI.m
//  Map
//
//  Created by Jakub Hladík on 07.11.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import "MyPOI.h"

@implementation MyPOI
{
    CLLocationCoordinate2D _coordinate;
}

- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

- (NSString *)title
{
    return self.placemark.subLocality;
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%f, %f", _coordinate.latitude, _coordinate.longitude];
}

@end
