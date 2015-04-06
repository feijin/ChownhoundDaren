//
//  ZJFHomeTableViewCell.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/4.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJFHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *nickNameButton;
@property (weak, nonatomic) IBOutlet UITextView *itemDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *moreDescriptionButton;
@property (weak, nonatomic) IBOutlet UILabel *prasiceNumber;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;


@end
