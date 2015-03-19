//
//  ZJFCurrentLocation.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/19.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJFLocation;

@interface ZJFCurrentLocation : NSObject
{
    NSMutableArray *locations;
}

- (ZJFLocation *)getCurrentLocation;

@end
