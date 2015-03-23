//
//  ZJFCurrentUser.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/23.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFCurrentUser.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation ZJFCurrentUser

@synthesize wbUid,isLogin,wbExpirationDate,wbRefreshToken,wbToken;

+ (ZJFCurrentUser *)shareUser{
    static ZJFCurrentUser *currentUser = nil;
    
    if (!currentUser) {
        currentUser = [[super allocWithZone:nil] init];
    }
    
    return currentUser;
}

//初始化时检测当前用户是否已登录
- (id)init{
    self = [super init];
    if (self) {
        if ([AVUser currentUser]) { 
            isLogin = true;
        }
    }
    
    return self;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self shareUser];
}





@end
