//
//  AppDelegate.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/2/28.
//  Copyright (c) 2015年 Chowhound Daren. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ZJFConfig.h"

@interface AppDelegate ()

#define AVOSCloudAppID  @"t9bgm027gebvc6gykqe40p2039lusyzuooj3b95yyxf229ph"
#define AVOSCloudAppKey @"8femkqs20j9y5a4wolylbt6cteb910a2hrb7vdmn1nx8prhw"

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [AVOSCloud setApplicationId:AVOSCloudAppID
                     clientKey:AVOSCloudAppKey];
   // [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    return YES;
}




@end
