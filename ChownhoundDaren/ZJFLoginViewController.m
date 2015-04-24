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
#import "ZJFCurrentUser.h"

@interface ZJFLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UILabel *loginTip;


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

//    tabbarVC.selectedIndex = 0;

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
            
            if (user != nil) {
                NSLog(@"%@ login succeeded!\n",user.username);
                
                //用户登录后，根据username更新currentuser的信息
                AVQuery *query = [AVQuery queryWithClassName:@"userInformation"];
                [query whereKey:@"username" equalTo:user.username];
                [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error){
                    if (!error) {
                        NSLog(@"查找到此用户的信息\n");
                        
                        [[ZJFCurrentUser shareCurrentUser] setUsername:[object objectForKey:@"username"]];
                        [[ZJFCurrentUser shareCurrentUser] setUserDescription:[object objectForKey:@"userDescription"]];
                        [[ZJFCurrentUser shareCurrentUser] setGender:[object objectForKey:@"gender"]];
                        [[ZJFCurrentUser shareCurrentUser] setNickName:[object objectForKey:@"nickName"]];
                        [[ZJFCurrentUser shareCurrentUser] setHeaderImage:[object objectForKey:@"headerData"]];
                        
                        NSLog(@"current user is: %@\n",[object objectForKey:@"nickName"]);
                        
                        if ([AVUser currentUser] == nil) {
                            NSLog(@"avuser currentuser = nil\n");
                        }
                        
                        [self dismissViewControllerAnimated:YES completion:
                            nil];
                    } else{
                        NSLog(@"查找此用户信息失败: %@\n", [error description]);
                    }
                }];
            } else {
                NSLog(@"未查询到此用户");
            }
        } else {
            NSLog(@"login fail:%@\n",[error description]);
            self.loginTip.text = @"用户名与密码不匹配，请重新输入";
            
            
        }
        
    }];
    
}

- (IBAction)resignResponder:(id)sender {
    [_emailAddress resignFirstResponder];
    [_passwordText resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 0) {
        [_passwordText becomeFirstResponder];
    } else if (textField.tag == 1){
        [_passwordText resignFirstResponder];
    }
    
    return YES;
}

@end
