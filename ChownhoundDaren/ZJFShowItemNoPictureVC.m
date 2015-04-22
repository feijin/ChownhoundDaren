//
//  ZJFShowItemNoPictureVC.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/20.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFShowItemNoPictureVC.h"
#import "ZJFShareItem.h"
#import "ZJFProfileCollectionViewController.h"

@interface ZJFShowItemNoPictureVC ()
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UILabel *nickNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;



@end

@implementation ZJFShowItemNoPictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nickNamelabel.text = _item.nickName;
    self.descriptionTextView.text = _item.itemDescription;
    self.placeNameLabel.text = _item.placeName;
    
    UIImage *image = [UIImage imageWithData:_item.headerImage scale:2.0];
    
    [self.headerButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.headerButton.layer.cornerRadius = 26;
    self.headerButton.clipsToBounds = YES;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd,hh-mm-ss";
    NSString *dateString = [dateFormatter stringFromDate:_item.createDate];
    self.createDateLabel.text = dateString;
    
    self.placeNameLabel.text = _item.placeName;
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowProfileFromNoPicture"]) {
        ZJFProfileCollectionViewController *profileVC = segue.destinationViewController;
        
        profileVC.username = _item.username;
    }
}


#pragma mark -设置页面

#pragma mark -计算控件高度



@end
