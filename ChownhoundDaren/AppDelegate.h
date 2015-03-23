//
//  AppDelegate.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/2/28.
//  Copyright (c) 2015年 Chowhound Daren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
@class ZJFLoginViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ZJFLoginViewController *loginViewController;



@end

