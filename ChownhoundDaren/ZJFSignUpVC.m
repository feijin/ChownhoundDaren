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

@interface ZJFSignUpVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *signUpEmail;
@property (weak, nonatomic) IBOutlet UITextField *signUpPassword;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordCheck;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UITextField *nickNameLabel;

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
            NSLog(@"注册成功,请及时登陆邮箱进行验证\n");
            self.tipsLabel.text = @"注册成功,请及时登陆邮箱进行验证";
            [AVUser logOut];
            
            AVObject *object = [AVObject objectWithClassName:@"userInformation"];
            
            [object setObject:_signUpEmail.text forKey:@"username"];
            [object setObject:_nickNameLabel.text forKey:@"nickName"];
            [object saveInBackground];
            
        } else {
            NSLog(@"注册失败: %@\n",[error description]);
        }
    }];
    
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)resignResponder:(id)sender {
    [_signUpEmail resignFirstResponder];
    [_signUpPassword resignFirstResponder];
    [_nickNameLabel resignFirstResponder];
    
}

- (IBAction)checkPassword:(id)sender {
    if(_signUpPassword.text.length < 8) {
        self.passwordCheck.text = @"密码长度至少8位";
        self.signUpButton.enabled = NO;
        
    } else{
        self.signUpButton.enabled = YES;
    }
}

- (IBAction)passwordEditBegin:(id)sender {
    self.passwordCheck.text = @"";
}

- (IBAction)nickNameEditBegin:(id)sender {
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    //上移n个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-50,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

- (IBAction)nickNameEditEnd:(id)sender {
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    //上移n个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,50,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}



@end
