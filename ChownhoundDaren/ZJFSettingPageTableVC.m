//
//  ZJFSettingPageTableVC.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFSettingPageTableVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ZJFCurrentUser.h"

@implementation ZJFSettingPageTableVC






- (IBAction)logout:(id)sender {
    [AVUser logOut];
    
    [ZJFCurrentUser shareCurrentUser].username = nil;
    [ZJFCurrentUser shareCurrentUser].nickName = nil;
    [ZJFCurrentUser shareCurrentUser].userDescription = nil;
    [ZJFCurrentUser shareCurrentUser].gender = nil;
    [ZJFCurrentUser shareCurrentUser].headerImage = nil;
    [ZJFCurrentUser shareCurrentUser].city = nil;
}

@end
