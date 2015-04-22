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
#import "ZJFShareItem.h"
#import "ZJFSNearlyItemStore.h"
#import "ZJFWeiboLoginInfo.h"


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
        NSLog(@"微博注册成功\n");
    } else {
        NSLog(@"微博注册失败\n");
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
            [self setWeiboLongiInfo:authorizeRespinse];
            
            //根据userid获取用户详细信息，如用户名，性别等
            [WBHttpRequest requestForUserProfile:[ZJFWeiboLoginInfo shareWeiboLoginInfo].wbUid withAccessToken:[ZJFWeiboLoginInfo shareWeiboLoginInfo].wbToken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *request, id result, NSError *error){
                if (!error) {
                    NSLog(@"request for user profile succeeded!\n");
                    
                    WeiboUser *userResult = (WeiboUser *)result;
                    [ZJFCurrentUser shareCurrentUser].weiboUser = userResult;
                    
                    //向云端查询此微博用户此前是否登录注册过
                    AVQuery *query = [AVUser query];
                    [query whereKey:@"username" equalTo:[ZJFCurrentUser shareCurrentUser].username];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
                        if (!error) {
                            if ([array count]==0) {
                                //如果用户此前没有注册过，则注册为新用户
                                AVUser *user = [AVUser user];
                                user.username = userResult.userID;
                                user.password = @"ChownhoundDaren";
                                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                    if (succeeded) {
                                        [[ZJFCurrentUser shareCurrentUser] setUsername:userResult.userID];
                                        [[ZJFCurrentUser shareCurrentUser] setGender:userResult.gender];
                                        [[ZJFCurrentUser shareCurrentUser] setUserDescription:userResult.userDescription];
                                        [[ZJFCurrentUser shareCurrentUser] setNickName:userResult.name];
                                        
                                        NSLog(@"signUp succeeded!\n");
                                        NSLog(@"nickname: %@\n", [[AVUser currentUser] objectForKey:@"nickName"]);
                                        
                                        [self.loginViewController dismissViewControllerAnimated:YES completion:nil];
                                    } else {
                                    }
                                }];
                                
                                //将用户信息保存到一个新的类中，而不是放在user中，
                                AVObject *object = [AVObject objectWithClassName:@"userInformation"];
                                [object setObject:userResult.userID forKey:@"username"]; //唯一性
                                [object setObject:userResult.gender forKey:@"gender"];
                                [object setObject:userResult.name forKey:@"nickName"];
                                [object setObject:userResult.userDescription forKey:@"userDescription"];
                                [object setObject:[NSNumber numberWithBool:true] forKey:@"isWeiboUser"];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                    if (succeeded) {
                                        NSLog(@"微博用户信息保存到userinformation类成功！\n");
                                    } else{
                                        NSLog(@"微博用户信息保存到userinformation error: %@\n",error);
                                    }
                                }];
                                
                                
                            } else if([array count]==1) {
                                //如果注册过，则使用wbUid登录到系统中
                                NSLog(@"user has signed!\n");
                                [AVUser logInWithUsernameInBackground:[ZJFWeiboLoginInfo shareWeiboLoginInfo].wbUid password:@"ChownhoundDaren" block:^(AVUser *user, NSError *error){
                
                                    if (user != nil) {
                                        NSLog(@"weibo login succeeded!\n");
                                        
                                        //微博用户登录后，根据username更新currentuser的信息
                                        AVQuery *query = [AVQuery queryWithClassName:@"userInformation"];
                                        [query whereKey:@"username" equalTo:user.username];
                                        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error){
                                            if (!error) {
                                                NSLog(@"查找到此微博用户的信息\n");
                                                
                                                [[ZJFCurrentUser shareCurrentUser] setUsername:[object objectForKey:@"username"]];
                                                [[ZJFCurrentUser shareCurrentUser] setUserDescription:[object objectForKey:@"userDescription"]];
                                                [[ZJFCurrentUser shareCurrentUser] setGender:[object objectForKey:@"gender"]];
                                                [[ZJFCurrentUser shareCurrentUser] setNickName:[object objectForKey:@"nickName"]];
                                                [[ZJFCurrentUser shareCurrentUser] setHeaderImage:[object objectForKey:@"headerData"]];
                                                
                                                NSLog(@"current user is: %@\n",[object objectForKey:@"nickName"]);
                                                
                                                [self.loginViewController dismissViewControllerAnimated:YES completion:nil];
                                                
                                                if ([AVUser currentUser] == nil) {
                                                    NSLog(@"avuser currentuser = nil\n");
                                                }
                                            } else{
                                                NSLog(@"查找此用户信息失败: %@\n", [error description]);
                                            }
                                        }];
                                    } else {
                                        NSLog(@"login fail: %@\n", [error description]);
                                    }
                                }];
                            }
                        } else{
                            NSLog(@"search fail\n");
                        }
                    }];

                } else {
                    NSLog(@"request for user profile fail!\n");
                }
            }];
        }
        
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
 //   [[[ZJFCurrentLocation shareStore] locationManager] stopUpdatingLocation];
 //   NSLog(@"stop update location.\n");
    
    BOOL success = [[ZJFSNearlyItemStore shareStore] saveChanges];
    
    if (success) {
        NSLog(@"Saved all of the items\n");
    } else {
        NSLog(@"Could not save any of the items\n");
    }
}

#pragma mark -保存登录等信息

//保存微博接口信息
- (void)setWeiboLongiInfo:(WBAuthorizeResponse *)response{
    [ZJFWeiboLoginInfo shareWeiboLoginInfo].wbUid = response.userID;
    [ZJFWeiboLoginInfo shareWeiboLoginInfo].wbToken = response.accessToken;
    [ZJFWeiboLoginInfo shareWeiboLoginInfo].wbExpirationDate = response.expirationDate;
    [ZJFWeiboLoginInfo shareWeiboLoginInfo].wbRefreshToken = response.refreshToken;
    [ZJFCurrentUser shareCurrentUser].username = response.userID;
}


@end
