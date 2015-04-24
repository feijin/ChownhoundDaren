//
//  ZJFFindPasswordVC.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/24.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFFindPasswordVC.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ZJFFindPasswordVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *resetPasswordTip;

@end

@implementation ZJFFindPasswordVC

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
- (IBAction)send:(id)sender {
    [AVUser requestPasswordResetForEmailInBackground:_emailTextField.text block:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            self.resetPasswordTip.text = @"重置链接发送成功，请登录邮箱重置密码";
        } else {
            NSLog(@"重置链接发送失败：%@\n",error);
        }
    }];
    
}

- (IBAction)resignResponder:(id)sender {
    [_emailTextField resignFirstResponder];
}


@end
