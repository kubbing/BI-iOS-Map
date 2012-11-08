//
//  LocationService.m
//  Map
//
//  Created by Jakub Hladík on 07.11.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import "LocationService.h"

@implementation LocationService

- (CLLo)

+ (LocationService *)sharedManager
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[LocationService alloc] init];
    });
}



@end
