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

@synthesize weiboUser,wbUid,wbExpirationDate,wbRefreshToken,wbToken,isLogin;

+ (ZJFCurrentUser *)shareCurrentUser{
    static ZJFCurrentUser *currentUser = nil;
    if (!currentUser) {
        currentUser = [[super allocWithZone:nil] init];
    }
    
    return currentUser;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self shareCurrentUser];
}

- (id)init{
    self = [super init];
    
    if (self) {
        if ([AVUser currentUser]) {
            isLogin = true;
            
        }
    }
    
    return self;
}




@end
