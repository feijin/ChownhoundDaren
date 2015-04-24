//
//  ZJFChangePasswordVC.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/24.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFChangePasswordVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ZJFCurrentUser.h"

@interface ZJFChangePasswordVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *origPassword;
@property (weak, nonatomic) IBOutlet UITextField *nowPassword;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *isSamePassword;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@end

@implementation ZJFChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)checkPassword:(id)sender {
    if ([_nowPassword.text length] < 8) {
        self.isSamePassword.text = @"密码长度不少于8位！";
        self.submitButton.enabled = NO;
        [self.submitButton setTitle:@"提交" forState:UIControlStateDisabled];
    } else {
        self.submitButton.enabled = YES;
    }
}

- (IBAction)submit:(id)sender {
    //确保用户当前的有效登录状态
    [AVUser logInWithUsernameInBackground:[ZJFCurrentUser shareCurrentUser].username password:_origPassword.text block:^(AVUser *user, NSError *error){
        if (!error) {
            if (user != nil) {
                [[AVUser currentUser] updatePassword:_origPassword.text     newPassword:_nowPassword.text block:^(id object, NSError *error) {
                    if (!error) {
                        self.tipLabel.text = @"更新密码成功";
                    }
                }];
            }
        } else{
            NSLog(@"原密码登陆失败：%@\n",error);
            self.tipLabel.text = @"原密码错误";
        }
        
    }];
    
 
    
    
}



@end
