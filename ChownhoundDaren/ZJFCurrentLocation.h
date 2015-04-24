//
//  ZJFCurrentLocation.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/19.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface ZJFCurrentLocation : NSObject
{
    
}

@property (nonatomic,strong) CLLocation *location;
@property (nonatomic,strong) CLLocationManager *locationManager;

+ (ZJFCurrentLocation *)shareStore;
- (CLLocation *)location;
- (CLLocationManager *)locationManager;


@end
