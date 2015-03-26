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
    
}


@property (nonatomic,strong) WeiboUser *weiboUser;
@property (nonatomic,strong) NSString *wbUid;
@property (nonatomic,strong) NSString *wbToken;
@property (nonatomic,strong) NSDate *wbExpirationDate;
@property (nonatomic,strong) NSString *wbRefreshToken;
@property (nonatomic,strong) NSString *userDescription;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *city;

+ (ZJFCurrentUser *)shareCurrentUser;
- (BOOL)isLogin;
- (void)setNickName:(NSString *)nickName;
- (void)setUserDescription:(NSString *)userDescription;
- (void)setGender:(NSString *)gender;
- (void)setCity:(NSString *)city;

- (NSString *)getNickname;
- (NSString *)getGender;
- (NSString *)getUserDescription;
- (NSString *)getCity;

@end
