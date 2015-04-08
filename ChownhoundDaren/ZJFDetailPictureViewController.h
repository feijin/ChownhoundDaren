//
//  ZJFDetailPictureViewController.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/31.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJFDetailPictureViewController : UIViewController
<UIGestureRecognizerDelegate>

@property (nonatomic,strong)   NSString *imageKey;
@property (nonatomic,strong)   NSDictionary *imageStore;
@property (nonatomic,strong)   UIImage *image;


@end
