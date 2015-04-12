//
//  ZJFShowItemVC.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFShowItemVC.h"
#import "ZJFShareItem.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ZJFShowItemVC ()

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UIButton *placeName;
@property (weak, nonatomic) IBOutlet UILabel *createDate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //使用AVRelation 来构建收藏关系(多对多）；
    
    //因为avrelation 对象的 addObject方法只能添加avobject对象，所以需要先根据objectid将此item从服务器获取下来
    AVQuery *queryItem = [AVQuery queryWithClassName:@"shareItem"];
    [queryItem whereKey:@"objectId" equalTo:_item.objectId];
    
    __weak typeof(self) weakSelf = self;
    [queryItem getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error){
        if (!error) {
            AVObject *shareItem = object; //获取待收藏的item
            
            //在userinformation中关联此收藏关系，同样需要先从服务器获取此user对象
            AVQuery *queryUser = [AVQuery queryWithClassName:@"userInformation"];
            [queryUser selectKeys:@[@"username"]];
            [queryUser whereKey:@"username" equalTo:[AVUser currentUser].username];
            
            [queryUser getFirstObjectInBackgroundWithBlock:^(AVObject *object,NSError *error){
                if (!error) {
                    AVObject *user = object;    //当前用户的information信息
                    
                    AVRelation *relation = [user relationforKey:@"collection"];  //获取当前用户收藏列表
                    
                    //查询当前用户是否已经收藏此信息
                    AVQuery *query = [relation query];
                    [query whereKey:@"objectId" equalTo:shareItem.objectId];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error){
                        if (!error) {
                            NSLog(@"查找shareitem成功\n");
                            
                            if ([objects count] != 0) {
                                //用户已经收藏了此信息
                                weakSelf.rightBarButton.title = @"取消收藏";
                            } else {
                                weakSelf.rightBarButton.title = @"收藏";
                            }
                        }
                    }];
                }
            }];
           
        }
    }];
    
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (IBAction)collect:(id)sender {
    //使用AVRelation 来构建收藏关系(多对多）；
    
    //因为avrelation 对象的 addObject方法只能添加avobject对象，所以需要先根据objectid将此item从服务器获取下来
    AVQuery *queryItem = [AVQuery queryWithClassName:@"shareItem"];
    [queryItem whereKey:@"objectId" equalTo:_item.objectId];
    
    AVObject *shareItem = [queryItem getFirstObject];  //待收藏的item
    
    //在userinformation中关联此收藏关系，同样需要先从服务器获取此user对象
    AVQuery *queryUser = [AVQuery queryWithClassName:@"userInformation"];
    [queryUser selectKeys:@[@"username"]];
    [queryUser whereKey:@"username" equalTo:[AVUser currentUser].username];
    
    AVObject *user = [queryUser getFirstObject];    //当前用户的information信息
    AVRelation *relation = [user relationforKey:@"collection"];  //获取当前用户收藏列表
    
    __weak typeof(self) weakSelf = self;
    if ([self.rightBarButton.title isEqualToString:@"收藏"]) {
        //此信息尚未被用户收藏
        [relation addObject:shareItem];
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded,NSError *error){
            if (!error) {
                NSLog(@"收藏成功\n");
                weakSelf.rightBarButton.title = @"取消收藏";
            } else {
                NSLog(@"收藏失败：%@\n",error);
            }
        }];
    } else {
        if ([self.rightBarButton.title isEqualToString:@"取消收藏"]) {
            //此信息已被用户收藏，取消收藏
            [relation removeObject:shareItem];
            
            [user saveInBackgroundWithBlock:^(BOOL succeeded,NSError *error){
                if (!error) {
                    NSLog(@"成功取消收藏\n");
                    
                    weakSelf.rightBarButton.title = @"收藏";
                } else {
                    NSLog(@"收藏失败：%@\n",error);
                }
            }];
        }
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
