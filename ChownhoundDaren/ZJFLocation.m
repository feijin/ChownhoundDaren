//
//  ZJFLocation.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/10.
//  Copyright (c) 2015年 Chowhound Daren. All rights reserved.
//

#import "ZJFLocation.h"

@implementation ZJFLocation

@synthesize createDate;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        createDate = [NSDate date];
    }
    
    return self;
}

@end
