//
//  ZJFHomeTableViewController.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ZJFHomeTableViewController : UITableViewController
<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>


@property (nonatomic,strong) CLLocationManager *locationManager;




@end