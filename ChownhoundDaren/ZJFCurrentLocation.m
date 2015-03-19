//
//  ZJFCurrentLocation.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/19.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFCurrentLocation.h"
#import "ZJFLocation.h"

@implementation ZJFCurrentLocation

- (ZJFLocation *)getCurrentLocation{
    return [locations lastObject];
}

@end
