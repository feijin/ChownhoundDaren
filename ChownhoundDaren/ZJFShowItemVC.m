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
#import "ZJFProfileCollectionViewController.h"
#import "ZJFDetailPictureViewController.h"
#import "ZJFCurrentUser.h"

@interface ZJFShowItemVC ()
{
    int buttonTag; //页面跳转时的图片顺序
}

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *createDate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;




@end

@implementation ZJFShowItemVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.nickName.text = _item.nickName;
    self.descriptionText.text = _item.itemDescription;
    self.placeName.text = _item.placeName;
    
    UIImage *image = [UIImage imageWithData:_item.headerImage scale:2.0];
    
    [self.headerButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.headerButton.layer.cornerRadius = 26;
    self.headerButton.clipsToBounds = YES;
    
    NSLog(@"header width: %d, height: %d\n",_headerButton.frame.origin.x, _headerButton.frame.origin.y);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd,hh-mm-ss";
    NSString *dateString = [dateFormatter stringFromDate:_item.createDate];
    self.createDate.text = dateString;
    
    self.placeName.text = _item.placeName;
    
    //显示信息中的图片
    
    NSArray *thumbnailKeys = [[_item thumbnailData] allKeys];
    for (int i=0; i<[thumbnailKeys count]; i++) {
        //处理信息中包含的图片
        switch (i) {
            case 0:{
                NSData *imageData = [[_item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                
                self.image1.image = image;
                self.image1.tag = 0;
                
                self.button1.enabled = YES;
                self.button2.enabled = NO;
                self.button3.enabled = NO;
                
                // NSLog(@"image1 size wigth: %f, heigth: %f\n",cell.image1.image.size.width,cell.image1.image.size.height);
                
                self.image2.image = nil;
                self.image3.image = nil;
                break;
            }
            case 1:{
                NSData *imageData = [[_item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                
                self.image2.image = image;
                self.image2.tag = 1;
                
                self.button2.enabled = YES;
                
                self.image3.image = nil;
                break;
            }
            case 2:{
                NSData *imageData = [[_item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                
                self.image3.image = image;
                self.image3.tag = 2;
                
                self.button3.enabled = YES;
                
                break;
            }
            default:
                break;
        }
        
    }
    
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[self.tabBarController tabBar] setHidden:YES];
    
    //使用AVRelation 来构建收藏关系(多对多）；
    
    //因为avrelation 对象的 addObject方法只能添加avobject对象，所以需要先根据objectid将此item从服务器获取下来
    if ([[ZJFCurrentUser shareCurrentUser] isLogin]) {
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
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark -收藏
- (IBAction)collect:(id)sender {
    
    //如果用户尚未登录，则提示先登录
    if (![[ZJFCurrentUser shareCurrentUser] isLogin]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"收藏信息需要登录，请先登录再收藏此信息!" preferredStyle:UIAlertControllerStyleAlert];
        
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

#pragma mark -页面跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowProfileFromPicture"]) {
        ZJFProfileCollectionViewController *profileVC = segue.destinationViewController;
        
        profileVC.username = _item.username;
    } else if ([segue.identifier isEqualToString:@"DetailPictureFromHomeItem"]){
        
        ZJFDetailPictureViewController *detailPictureViewController = segue.destinationViewController;
        
        NSString *key = [[[_item thumbnailData] allKeys] objectAtIndex:buttonTag];
        
        detailPictureViewController.imageKey = key;
        detailPictureViewController.imageStore = _item.imageStore;
        
    }
}

- (IBAction)showImage:(id)sender {
    [self performSegueWithIdentifier:@"DetailPictureFromHomeItem" sender:sender];
    
    UIButton *button = (UIButton *)sender;
    buttonTag = button.tag;
    
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
