//
//  ZJFLoginViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFLoginViewController.h"
#import "AppDelegate.h"
#import "WBHttpRequest+WeiboToken.h"
#import "WeiboSDK.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ZJFLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;


@end

@implementation ZJFLoginViewController
@synthesize isCancelLogin;

- (void)viewDidLoad {
    [super viewDidLoad];

    
}


#pragma mark -登录页面
- (IBAction)cancelLogin:(id)sender {
    self.isCancelLogin = true;
    //取消登录，返回到首页
    [self dismissViewControllerAnimated:YES completion:nil];
    UITabBarController *tabbarVC = (UITabBarController *)[self presentingViewController];
    
    tabbarVC.selectedIndex = 0;

}

- (IBAction)loginWithWeibo:(id)sender {
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.loginViewController = self;
    
    
    if ([WeiboSDK isCanSSOInWeiboApp]) {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
//        request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        request.scope = nil;

        [WeiboSDK sendRequest:request];
        NSLog(@"请求成功\n");
        
    } else {
        NSLog(@"无法使用sso登录\n");
    }
    
   
}

- (IBAction)loginWithUsername:(id)sender {
    [AVUser logInWithUsernameInBackground:_emailAddress.text password:_passwordText.text block:^(AVUser *user, NSError *error){
        if (!error) {
            NSLog(@"login succeed!\n");
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"login fail:%@\n",[error description]);
        }
        
    }];
    
}



#pragma mark -有效性检测




@end
