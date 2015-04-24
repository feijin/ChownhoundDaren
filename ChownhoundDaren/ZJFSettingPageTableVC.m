//
//  ZJFSettingPageTableVC.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFSettingPageTableVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ZJFCurrentUser.h"
#import "ZJFSNearlyItemStore.h"
#import "ZJFImageStore.h"

@interface ZJFSettingPageTableVC ()

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@end

@implementation ZJFSettingPageTableVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[self.tabBarController tabBar] setHidden:YES];
    
    if (![AVUser currentUser]) {
        self.logoutButton.enabled = NO;
        [self.logoutButton setTitle:@"尚未登录" forState:UIControlStateDisabled];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[self.tabBarController tabBar] setHidden:NO];
}

- (IBAction)clearSystem:(id)sender {
    [[ZJFImageStore shareStore] deleteAllImage];
    [[ZJFSNearlyItemStore shareStore] deleteAllItem];
}

- (IBAction)rateUs:(id)sender {
    
    NSString *string = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",547203890];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    
}



- (IBAction)logout:(id)sender {
    if(![AVUser currentUser])   //未登录则不做任何事情
        return;
    
    [AVUser logOut];
    
    [ZJFCurrentUser shareCurrentUser].username = nil;
    [ZJFCurrentUser shareCurrentUser].nickName = nil;
    [ZJFCurrentUser shareCurrentUser].userDescription = nil;
    [ZJFCurrentUser shareCurrentUser].gender = nil;
    [ZJFCurrentUser shareCurrentUser].headerImage = nil;
    [ZJFCurrentUser shareCurrentUser].city = nil;
    
    [[ZJFSNearlyItemStore shareStore] deleteMyShareItems];
    
    UIButton *button = (UIButton *)sender;
    [button setEnabled:NO];
    [button setTitle:@"退出成功" forState:UIControlStateDisabled];
}



@end
