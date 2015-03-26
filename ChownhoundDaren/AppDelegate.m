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
#import "WeiboUser.h"
#import "WBHttpRequest+WeiboUser.h"
#import "ZJFCurrentLocation.h"


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
            
            //将微博授权信息保存起来
            [ZJFCurrentUser shareCurrentUser].wbUid = authorizeRespinse.userID;
            [ZJFCurrentUser shareCurrentUser].wbToken = authorizeRespinse.accessToken;
            [ZJFCurrentUser shareCurrentUser].wbExpirationDate = authorizeRespinse.expirationDate;
            [ZJFCurrentUser shareCurrentUser].wbRefreshToken = authorizeRespinse.refreshToken;
            
            //根据userid获取用户详细信息，如用户名，性别等
            [WBHttpRequest requestForUserProfile:[ZJFCurrentUser shareCurrentUser].wbUid withAccessToken:[ZJFCurrentUser shareCurrentUser].wbToken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *request, id result, NSError *error){
                if (!error) {
                    NSLog(@"request for user profile succeeded!\n");
                    [ZJFCurrentUser shareCurrentUser].weiboUser = result;
                    WeiboUser *userResult = (WeiboUser *)result;
                    
                    //向云端查询此微博用户此前是否登录注册过
                    AVQuery *query = [AVUser query];
                    [query whereKey:@"username" equalTo:[ZJFCurrentUser shareCurrentUser].wbUid];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
                        if (!error) {
                            if ([array count]==0) {
                                //如果用户此前没有注册过，则注册为新用户
                                AVUser *user = [AVUser user];
                                user.username = [ZJFCurrentUser shareCurrentUser].wbUid;
                                user.password = @"ChownhoundDaren";
                                [user setObject:userResult.gender forKey:@"gender"];
                                [user setObject:userResult.name forKey:@"nickName"];
                                [user setObject:[NSNumber numberWithBool:true] forKey:@"isWeiboUser"];
                                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                    if (succeeded) {
                                        [[ZJFCurrentUser shareCurrentUser] setGender:userResult.gender];
                                        [[ZJFCurrentUser shareCurrentUser] setUserDescription:userResult.description];
                                        [[ZJFCurrentUser shareCurrentUser] setNickName:userResult.name];
                                        
                                        NSLog(@"signUp succeeded!\n");
                                        NSLog(@"nickname: %@\n", [[AVUser currentUser] objectForKey:@"nickName"]);
                                    } else {
                                    }
                                }];
                            } else if([array count]==1) {
                                //如果注册过，则使用wbUid登录到系统中
                                NSLog(@"user has signed up!\n");
                                [AVUser logInWithUsernameInBackground:[ZJFCurrentUser shareCurrentUser].wbUid password:@"ChownhoundDaren" block:^(AVUser *user, NSError *error){
                                    if (user != nil) {
                                        NSLog(@"login succeeded!\n");
                                        NSLog(@"current user is: %@\n",[user objectForKey:@"nickName"]);
                                    } else {
                                        NSLog(@"login fail: %@\n", [error description]);
                                    }
                                }];
                            }
                        } else{
                            NSLog(@"seach fail\n");
                        }
                    }];

                } else {
                    NSLog(@"request for user profile fail!\n");
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

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [[[ZJFCurrentLocation shareStore] locationManager] stopUpdatingLocation];
}

- (void)applicationWillResignActive:(UIApplication *)application{
    [[[ZJFCurrentLocation shareStore] locationManager] startUpdatingLocation];
}


@end
