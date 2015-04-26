//
//  ZJFShowItemVC.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJFShareItem;

@interface ZJFShowItemVC : UIViewController

@property (nonatomic,strong) ZJFShareItem *item;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (nonatomic,strong) NSString *sourceVC;

@end
