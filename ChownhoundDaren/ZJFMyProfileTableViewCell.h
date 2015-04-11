//
//  ZJFMyProfileTableViewCell.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/24.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJFMyProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOfShares;
@property (weak, nonatomic) IBOutlet UILabel *labelOfShares;

@end
