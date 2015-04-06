//
//  ZJFWeiboLoginInfo.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/6.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJFWeiboLoginInfo : NSObject

@property (nonatomic,strong) NSString *wbUid;
@property (nonatomic,strong) NSString *wbToken;
@property (nonatomic,strong) NSDate *wbExpirationDate;
@property (nonatomic,strong) NSString *wbRefreshToken;


+ (ZJFWeiboLoginInfo *)shareWeiboLoginInfo;
@end
