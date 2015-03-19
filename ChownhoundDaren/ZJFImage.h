//
//  ZJFImage.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/18.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//此类主要用于上传功能中，当从图库中选择一张图片时，会生成唯一标志符与图片一起保存在此类中，以供
//ZJFCreateItemCollectionViewController.m 类使用。

#import <UIKit/UIKit.h>

@interface ZJFImage : NSObject

@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *imageKey;

- (id)initWithImage:(UIImage *)image key:(NSString *)key;

@end
