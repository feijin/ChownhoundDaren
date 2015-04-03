//
//  ZJFTestViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/3.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFTestViewController.h"
#import "ZJFSNearlyItemStore.h"
#import "ZJFShareItem.h"

@implementation ZJFTestViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"2"];
    NSLog(@"%f;%f\n",image.size.width,image.size.height);
    
    ZJFShareItem *item = [[ZJFShareItem alloc] init];
    
    self.imageView.image = [item getThumbnail:image];
    
//    NSLog(@"image width: %f, heigth: %f\n",self.imageView.image.size.width,self.imageView.image.size.height);
}

@end
