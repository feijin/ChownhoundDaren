//
//  AppDelegate.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/2/28.
//  Copyright (c) 2015年 Chowhound Daren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>
{
    NSString *wbToken;
    NSString *wbCurrentUserID;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSString *wbToken;
@property (nonatomic,strong) NSString *wbCurrentUserID;
@property (nonatomic,strong) NSDate *wbExpirationDate;
@property (nonatomic,strong) NSString *wbRefreshToken;


@end

