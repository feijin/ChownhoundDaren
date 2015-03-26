//
//  ZJFSetMyProfileViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/26.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFSetMyProfileViewController.h"
#import "ZJFCurrentUser.h"

@interface ZJFSetMyProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *signatureTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

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
    
    if (self.nickNameTextField.text != nil) {
        [ZJFCurrentUser shareCurrentUser].nickName = self.nickNameTextField.text;
        NSLog(@"%@\n",[[ZJFCurrentUser shareCurrentUser] nickName]);
    }
    
    if (self.signatureTextField.text != nil)
    {
        [ZJFCurrentUser shareCurrentUser].userDescription = self.signatureTextField.text;
    }
    
    if (self.cityTextField.text != nil) {
        [ZJFCurrentUser shareCurrentUser].city = self.cityTextField.text;
    }
}


- (IBAction)selectCity:(id)sender {
    
}






@end
