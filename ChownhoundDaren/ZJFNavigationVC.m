//
//  ZJFNavigationVC.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/23.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFNavigationVC.h"
#import <UIKit/UIKit.h>

@interface ZJFNavigationVC ()

@end

@implementation ZJFNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"shouye"];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:image selectedImage:nil];
    self.tabBarItem = tabBarItem;
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

@end
