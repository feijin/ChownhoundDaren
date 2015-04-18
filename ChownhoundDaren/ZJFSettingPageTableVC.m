//
//  ZJFSettingPageTableVC.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFSettingPageTableVC.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation ZJFSettingPageTableVC

- (IBAction)logout:(id)sender {
    [AVUser logOut];
}

@end
