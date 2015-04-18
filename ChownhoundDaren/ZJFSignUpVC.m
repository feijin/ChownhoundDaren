//
//  ZJFSignUpVC.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/13.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFSignUpVC.h"
#import <AVOSCloud/AVOSCloud.h>

#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

#define REGEX_PASSWORD_LIMIT @"^.{8,20}$"
#define REGEX_PASSWORD @"^[a-zA-Z0-9]{8,20}+$"

@interface ZJFSignUpVC ()

@property (weak, nonatomic) IBOutlet UITextField *signUpEmail;
@property (weak, nonatomic) IBOutlet UITextField *signUpPassword;

@end

@implementation ZJFSignUpVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
}


- (IBAction)signUp:(id)sender {
    AVUser *user = [AVUser user];
    user.username = _signUpEmail.text;
    user.password = _signUpPassword.text;
    user.email = _signUpEmail.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeed,NSError *error){
        if (succeed) {
            NSLog(@"注册成功,请登录邮箱进行验证\n");
            [self.navigationController popViewControllerAnimated:YES];
            [AVUser logOut];
        } else {
            NSLog(@"注册失败: %@\n",[error description]);
        }
    }];
    
}


@end
