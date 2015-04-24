//
//  ZJFCurrentLocation.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/19.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFCurrentLocation.h"

@implementation ZJFCurrentLocation


+ (ZJFCurrentLocation *)shareStore{
    static ZJFCurrentLocation *shareStore = nil;
    
    if (!shareStore) {
        shareStore = [[super allocWithZone:nil] init];
    }
    
    return shareStore;
}

- (id)init{
    self = [super init];
    if (self) {
        _location = [[CLLocation alloc] init];
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    return self;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self shareStore];
}

- (CLLocation *)location{
    return _location;
}

- (CLLocationManager *)locationManager{
    return _locationManager;
}

@end
