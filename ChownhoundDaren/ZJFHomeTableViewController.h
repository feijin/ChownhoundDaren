//
//  ZJFHomeTableViewController.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJFLocation;

@interface ZJFHomeTableViewController : UITableViewController
<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) ZJFLocation *location;

- (IBAction)whereIsMe:(id)sender;  //确定当前位置;


@end