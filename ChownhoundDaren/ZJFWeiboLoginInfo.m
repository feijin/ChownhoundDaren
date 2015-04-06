//
//  ZJFWeiboLoginInfo.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/6.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFWeiboLoginInfo.h"

@implementation ZJFWeiboLoginInfo

@synthesize wbExpirationDate,wbRefreshToken,wbToken,wbUid;


+ (ZJFWeiboLoginInfo *)shareWeiboLoginInfo{
    static ZJFWeiboLoginInfo *shareInfo = nil;
    
    if (!shareInfo) {
        shareInfo = [[super allocWithZone:nil] init];
    }
    
    return shareInfo;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self shareWeiboLoginInfo];
}

@end
