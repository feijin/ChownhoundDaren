//
//  ZJFSetMyProfileViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/26.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFSetMyProfileViewController.h"
#import "ZJFCurrentUser.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ZJFSetMyProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *signatureTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (nonatomic,strong)NSString *gender;
@property (weak, nonatomic) IBOutlet UIButton *genderButton;

@end

@implementation ZJFSetMyProfileViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.nickNameTextField.text = [[ZJFCurrentUser shareCurrentUser] nickName];
    self.cityTextField.text = [[ZJFCurrentUser shareCurrentUser] city];
    
    if ([[ZJFCurrentUser shareCurrentUser] userDescription] != nil) {
        self.signatureTextField.text = [[ZJFCurrentUser shareCurrentUser] userDescription];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //先更新本地用户信息
    if (self.nickNameTextField.text != nil) {
        [ZJFCurrentUser shareCurrentUser].nickName = self.nickNameTextField.text;
        NSLog(@"%@\n",[[ZJFCurrentUser shareCurrentUser] nickName]);
    }
    
    [ZJFCurrentUser shareCurrentUser].userDescription = self.signatureTextField.text;
    NSLog(@"%@\n",[ZJFCurrentUser shareCurrentUser].userDescription);
    
    if (self.cityTextField.text != nil) {
        [ZJFCurrentUser shareCurrentUser].city = self.cityTextField.text;
    }
    
    //将更新后的信息上传至服务器
    AVQuery *query = [AVQuery queryWithClassName:@"userInformation"];
    [query whereKey:@"username" equalTo:[AVUser currentUser].username];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error){
        [object setObject:[ZJFCurrentUser shareCurrentUser].nickName forKey:@"nickName"];
        [object setObject:[ZJFCurrentUser shareCurrentUser].userDescription forKey:@"userDescription"];
        [object setObject:[ZJFCurrentUser shareCurrentUser].city forKey:@"city"];
        [object setObject:[ZJFCurrentUser shareCurrentUser].gender forKey:@"gender"];
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            
            if (succeeded) {
                NSLog(@"更新个人信息成功！\n");
            }else{
                NSLog(@ "更新个人信息失败：%@\n", error);
            }
        }];
    }];
    
}


- (IBAction)selectCity:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        self.gender = @"m";
        [ZJFCurrentUser shareCurrentUser].gender = @"m";
        self.genderButton.titleLabel.text = @"男";
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        self.gender = @"f";
        [ZJFCurrentUser shareCurrentUser].gender = @"f";
        self.genderButton.titleLabel.text = @"女";
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"其他" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        self.gender = @"o";
        [ZJFCurrentUser shareCurrentUser].gender = @"o";
        self.genderButton.titleLabel.text = @"同性";
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}






@end
