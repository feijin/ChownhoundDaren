//
//  ZJFCurrentUser.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/23.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboUser.h"

@interface ZJFCurrentUser : NSObject
{
    WeiboUser *wbUser;
}

@property (nonatomic,strong) NSString *wbUid;
@property (nonatomic,strong) NSString *wbToken;
@property (nonatomic,strong) NSDate *wbExpirationDate;
@property (nonatomic,strong) NSString *wbRefreshToken;
@property (nonatomic) BOOL isLogin;

+ (ZJFCurrentUser *)shareCurrentUser;


@end
