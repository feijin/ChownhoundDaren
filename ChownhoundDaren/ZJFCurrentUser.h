//
//  ZJFCurrentUser.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/23.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboUser.h"

@interface ZJFCurrentUser : NSObject<NSCoding>
{
    
}

@property (nonatomic,strong) WeiboUser *weiboUser;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *userDescription;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSData *headerImage;

+ (ZJFCurrentUser *)shareCurrentUser;
- (BOOL)isLogin;

@end
