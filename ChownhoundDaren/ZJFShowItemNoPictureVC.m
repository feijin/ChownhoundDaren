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
#import "ZJFCurrentUser.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ZJFShowItemNoPictureVC ()
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UILabel *nickNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;



@end

@implementation ZJFShowItemNoPictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_sourceVC isEqualToString:@"MyShareVC"]) {
        self.nickNamelabel.text = _item.nickName;
        self.descriptionTextView.text = _item.itemDescription;
        self.placeNameLabel.text = _item.placeName;
        
        UIImage *image = [UIImage imageWithData:_item.headerImage scale:2.0];
        
        [self.headerButton setBackgroundImage:image forState:UIControlStateNormal];
        
        self.headerButton.layer.cornerRadius = 26;
        self.headerButton.clipsToBounds = YES;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM月dd日,hh-mm";
        NSString *dateString = [dateFormatter stringFromDate:_item.createDate];
        self.createDateLabel.text = dateString;
        
        self.placeNameLabel.text = _item.placeName;

        //针对从我的分享跳转过来，进行页面修改
        self.rightBarButton.enabled = NO;
        self.rightBarButton.title = @" ";
        self.headerButton.enabled = NO;
        UIImage *selfHeader = [UIImage imageWithData:[ZJFCurrentUser shareCurrentUser].headerImage scale:2.0];
        
        [self.headerButton setBackgroundImage:selfHeader forState:UIControlStateNormal];
        self.nickNamelabel.text = @"我";
        

    } else {
        self.nickNamelabel.text = _item.nickName;
        self.descriptionTextView.text = _item.itemDescription;
        self.placeNameLabel.text = _item.placeName;
        
        UIImage *image = [UIImage imageWithData:_item.headerImage scale:2.0];
        
        [self.headerButton setBackgroundImage:image forState:UIControlStateNormal];
        
        self.headerButton.layer.cornerRadius = 26;
        self.headerButton.clipsToBounds = YES;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM月dd日,hh-mm";
        NSString *dateString = [dateFormatter stringFromDate:_item.createDate];
        self.createDateLabel.text = dateString;
        
        self.placeNameLabel.text = _item.placeName;

    }

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[self.tabBarController tabBar] setHidden:YES];
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

#pragma mark -收藏
- (IBAction)collect:(id)sender {
    
    //如果用户尚未登录，则提示先登录
    if (![[ZJFCurrentUser shareCurrentUser] isLogin]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"收藏信息需要登录，请先登录再收藏此信息!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
        
        
    }
    
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

#pragma mark -设置页面

#pragma mark -计算控件高度



@end
