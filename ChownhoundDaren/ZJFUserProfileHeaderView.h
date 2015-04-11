//
//  ZJFUserProfileHeaderView.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/10.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJFUserProfileHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinDate;
@property (weak, nonatomic) IBOutlet UITextView *userDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@end
