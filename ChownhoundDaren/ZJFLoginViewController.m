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

@interface ZJFLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)login:(id)sender;

@end

@implementation ZJFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTextField.secureTextEntry = YES;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"kai\n");
}

- (IBAction)cancelLogin:(id)sender {
    //取消登录，返回到首页
    [[self parentViewController].navigationController popToRootViewControllerAnimated:nil];
    
    //[self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -2)] animated:YES];
}

- (IBAction)forgotPassword:(id)sender {
}

- (IBAction)login:(id)sender {
    
    
}

- (IBAction)loginWithWeibo:(id)sender {
    
    if ([WeiboSDK isCanSSOInWeiboApp]) {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
//        request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        request.scope = nil;
        /*    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
         @"Other_Info_1": [NSNumber numberWithInt:123],
         @"Other_Info_2": @[@"obj1", @"obj2"],
         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
         */
        [WeiboSDK sendRequest:request];
        NSLog(@"请求成功\n");
        
    } else {
        NSLog(@"无法使用sso登录\n");
    }
    
   
}





@end
