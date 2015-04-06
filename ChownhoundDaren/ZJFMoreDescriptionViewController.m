//
//  ZJFMoreDescriptionViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/31.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFMoreDescriptionViewController.h"

@interface ZJFMoreDescriptionViewController ()
{
    
    __weak IBOutlet UITextView *descriptionTextView;
    __weak IBOutlet UILabel *nickNameLabel;
    __weak IBOutlet UILabel *createDateLabel;
}

@end

@implementation ZJFMoreDescriptionViewController

@synthesize item;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (item.nickName != nil) {
        nickNameLabel.text = item.nickName;
    } else {
        nickNameLabel.text = @"匿名";
    }
    
   //    createDateLabel.text = item.createDate;
    
    descriptionTextView.text = item.itemDescription;
}

@end
