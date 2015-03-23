//
//  AppDelegate.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/2/28.
//  Copyright (c) 2015年 Chowhound Daren. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ZJFCurrentUser.h"
#import "ZJFLoginViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize loginViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [AVOSCloud setApplicationId:@"t9bgm027gebvc6gykqe40p2039lusyzuooj3b95yyxf229ph"
                     clientKey:@"8femkqs20j9y5a4wolylbt6cteb910a2hrb7vdmn1nx8prhw"];
   // [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [WeiboSDK enableDebugMode:YES];
    if ([WeiboSDK registerApp: @"2364950450"]) {
        NSLog(@"注册成功\n");
    } else {
        NSLog(@"注册失败\n");
    }
    
    return YES;
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    //获取到微博用户uid，accesToken等，并保存到avuser中
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        NSLog(@"授权成功\n");
        
        if ([response isKindOfClass:WBAuthorizeResponse.class]) {
            WBAuthorizeResponse *authorizeRespinse = (WBAuthorizeResponse *)response;
            
            [ZJFCurrentUser shareCurrentUser].wbUid = authorizeRespinse.userID;
            [ZJFCurrentUser shareCurrentUser].wbToken = authorizeRespinse.accessToken;
            [ZJFCurrentUser shareCurrentUser].wbExpirationDate = authorizeRespinse.expirationDate;
            [ZJFCurrentUser shareCurrentUser].wbRefreshToken = authorizeRespinse.refreshToken;
            [ZJFCurrentUser shareCurrentUser].isLogin = true;
            
            AVUser *user = [AVUser user];
            user.username = [ZJFCurrentUser shareCurrentUser].wbUid;
            user.password = @"ChownhoundDaren";
            [user setObject:[NSNumber numberWithBool:YES] forKey:@"isWeiboUser"];
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded,NSError *error){
                if (succeeded) {
                    NSLog(@"sign up succeeded\n");
                } else{
                    NSLog(@"sign up fail\n");
                }
            }];
        }
        
        [self.loginViewController dismissViewControllerAnimated:YES completion:nil];
        
    } else{
        NSLog(@"授权失败\n");
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}


@end
