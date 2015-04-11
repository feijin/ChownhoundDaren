//
//  ZJFShowItemVC.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFShowItemVC.h"
#import "ZJFShareItem.h"

@interface ZJFShowItemVC ()

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UIButton *placeName;
@property (weak, nonatomic) IBOutlet UILabel *createDate;

@end

@implementation ZJFShowItemVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.nickName.text = _item.nickName;
    self.descriptionText.text = _item.itemDescription;
    self.placeName.titleLabel.text = _item.placeName;
    
    UIImage *image = [UIImage imageWithData:_item.headerImage scale:2.0];
    image = [self getThumbnail:image];
    
    self.headerImage.image = image;
    self.headerImage.layer.cornerRadius = 26;
    self.headerImage.clipsToBounds = YES;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:_item.createDate];
    self.createDate.text = dateString;
    
    self.placeName.titleLabel.text = _item.placeName;

}

- (IBAction)collect:(id)sender {
    
    UINavigationItem *item = (UINavigationItem *)sender;
    if ([item.title isEqualToString:@"收藏"]) {
        item.title = @"已收藏";
    } else {
        item.title = @"收藏";
    }
    
    
}


- (UIImage *)getThumbnail:(UIImage *)image{
    CGSize newSize = CGSizeMake(52, 52);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
