//
//  ZJFRegisterViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/21.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFRegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ZJFRegisterViewController ()


@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *verifyNumber;
@property (weak, nonatomic) IBOutlet UITextField *nickNameText;

@end

@implementation ZJFRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (IBAction)sendVerifyAgain:(id)sender {
    
}


- (IBAction)registerUser:(id)sender {
    //    long long phoneNumber = [[self.phoneNumberText text] longLongValue];
    
    AVUser *user = [AVUser user];
    
    //可以直接从手机读取的
    user.mobilePhoneNumber = self.phoneNumberText.text;
    //mobilePhoneNumber 属性即为userID

    user.username = self.nickNameText.text;
    user.password = self.passwordText.text;
    //  user.email = @"jinfeizh@gmail.com";
        NSError *error = nil;
    [user signUp:&error];
    
    if (!error) {
        NSLog(@"注册成功\n");
    } else {
        NSLog(@"%@\n",[error description]);
    }
    
    [AVUser verifyMobilePhone:user.mobilePhoneNumber withBlock:^(BOOL succeeded, NSError *error) {
        //验证结果
    }];

    

}

- (IBAction)resignFirstResponde:(id)sender {
    NSLog(@"111");
    [self.view endEditing:YES];
}



@end
