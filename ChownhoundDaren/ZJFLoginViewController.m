//
//  ZJFLoginViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFLoginViewController.h"

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
- (IBAction)cancelLogin:(id)sender {
    //取消登录，返回到首页
    [[self parentViewController].navigationController popToRootViewControllerAnimated:nil];
}

- (IBAction)forgotPassword:(id)sender {
}

- (IBAction)login:(id)sender {
    
    
}


@end
