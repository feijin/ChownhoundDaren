//
//  ZJFDetailOfCreateImageViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/18.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFDetailOfCreateImageViewController.h"
#import "ZJFCreateItemCollectionViewController.h"
#import "ZJFImage.h"

@interface ZJFDetailOfCreateImageViewController ()

@end

@implementation ZJFDetailOfCreateImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.imageWithKey.image;
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

- (IBAction)deleteImage:(id)sender {
    
    //移除父视图中相应照片
//    [self.captureImages removeObject:self.image];
    [self.createItemCollectionViewController deleteImage:self.imageWithKey];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)hideNavigationBar:(id)sender {
    if ([self.navigationController isNavigationBarHidden]) {
        [self.navigationController setNavigationBarHidden:NO animated:UINavigationControllerHideShowBarDuration];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:UINavigationControllerHideShowBarDuration];
    }
}

@end
