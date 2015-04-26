//
//  ZJFProfileCollectionViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/10.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFProfileCollectionViewController.h"
#import "ZJFUserProfileCC.h"
#import "ZJFSNearlyItemStore.h"
#import "ZJFShareItem.h"
#import "ZJFUserProfileHeaderView.h"
#import "ZJFUserProfile.h"
#import "MJRefresh.h"
#import "ZJFDetailPictureViewController.h"
#import "ZJFShowItemNoPictureVC.h"
#import "ZJFShowItemVC.h"
#import "ZJFUserProfileNoPictureCC.h"
#import "UIView+UIView_GetSuperView.h"
#import <AVOSCloud/AVOSCloud.h>

static int numberOfMaxCharacters = 150;

@interface ZJFProfileCollectionViewController (){

    ZJFShareItem *segueItem;
    ZJFUserProfileHeaderView *headerView; //保存header
    int buttonTag;  //用于显示图片时确定顺序
    ZJFUserProfile *userProfile;  //保存用户的资料信息
    
}

@end


@implementation ZJFProfileCollectionViewController

@synthesize username,nickName;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[ZJFSNearlyItemStore shareStore] getProfile:username];
    userProfile = [ZJFSNearlyItemStore shareStore].userProfile;
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@的主页",userProfile.nickName]];
    
    [ZJFSNearlyItemStore shareStore].profileCollectionViewController = self;
    [[ZJFSNearlyItemStore shareStore] downloadUserShareItemForRefreshWithUsername:username];
    [ZJFSNearlyItemStore shareStore].profileCollectionViewController = self;
    

    __weak typeof(self) weakSelf = self;
    [self.collectionView addLegendHeaderWithRefreshingBlock:^(){
        __strong typeof(self) strongSelf = weakSelf;
        //    [ZJFSNearlyItemStore shareStore].profileCollectionViewController = strongSelf;
        [[ZJFSNearlyItemStore shareStore] downloadUserShareItemForRefreshWithUsername:strongSelf.username];
    }];
    
    [self.collectionView addLegendFooterWithRefreshingBlock:^(){
        __strong typeof(self) strongSelf = weakSelf;
        //   [ZJFSNearlyItemStore shareStore].profileCollectionViewController = strongSelf;
        [[ZJFSNearlyItemStore shareStore] downloadUserShareItemAfterRefreshWithUsername:strongSelf.username];
    }];

    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark -collectionview datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[ZJFSNearlyItemStore shareStore] userShareItems].count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ZJFUserProfileHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileHeader" forIndexPath:indexPath];
    
    header.headerImage.image = [UIImage imageWithData:userProfile.headerImage scale:2.0];
    header.headerImage.layer.cornerRadius = 31;
    header.headerImage.clipsToBounds = YES;
    
    header.userSignature.text = userProfile.userDescription;
    header.nickName.text =userProfile.nickName;
    header.city.text = userProfile.city;
    
    headerView = header;
    
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] userShareItems] objectAtIndex:[indexPath row]];
    NSArray *thumbnailKeys = [[item thumbnailData] allKeys];
    
    if ([thumbnailKeys count] != 0) {
        ZJFUserProfileCC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserProfileCell" forIndexPath:indexPath];
        
        NSString *briefDescription = item.itemDescription;
        if (briefDescription.length > numberOfMaxCharacters) {
            briefDescription = [briefDescription substringToIndex:numberOfMaxCharacters];
            briefDescription = [briefDescription stringByAppendingString:@"..."];
        }
        
        cell.itemDescription.text = briefDescription;
        
        for (int i=0; i<[thumbnailKeys count]; i++) {
            switch (i) {
                case 0:{
                    NSData *imageData = [[item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                    UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                    
                    cell.image1.image = image;
                    cell.image1.tag = 0;
                    
                    //                  cell.button1.enabled = YES;
                    //                cell.button2.enabled = NO;
                    //              cell.button3.enabled = NO;
                    
                    // NSLog(@"image1 size wigth: %f, heigth: %f\n",cell.image1.image.size.width,cell.image1.image.size.height);
                    
                    cell.image2.image = nil;
                    cell.image3.image = nil;
                    break;
                }
                case 1:{
                    NSData *imageData = [[item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                    UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                    
                    cell.image2.image = image;
                    cell.image2.tag = 1;
                    
                    //                   cell.button2.enabled = YES;
                    
                    cell.image3.image = nil;
                    break;
                }
                case 2:{
                    NSData *imageData = [[item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                    UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                    
                    cell.image3.image = image;
                    cell.image3.tag = 2;
                    
                    //                    cell.button3.enabled = YES;
                    
                    break;
                }
                default:
                    break;
            }
            
        }
        
        NSLayoutConstraint *imageToButton = [NSLayoutConstraint constraintWithItem:cell
                                                                         attribute:NSLayoutAttributeBottomMargin
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:cell.image1
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                          constant:10];
        
        [cell addConstraint:imageToButton];
        
        return cell;
    } else {
        ZJFUserProfileNoPictureCC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCellNoPicture" forIndexPath:indexPath];
        
        NSString *briefDescription = item.itemDescription;
        if (briefDescription.length > numberOfMaxCharacters + 100) {
            //没图片的信息可以多显示一些文字
            briefDescription = [briefDescription substringToIndex:numberOfMaxCharacters + 100];
            briefDescription = [briefDescription stringByAppendingString:@"..."];
        }
        
        cell.itemDescription.text = briefDescription;
        
        NSLayoutConstraint *labelToButtom = [NSLayoutConstraint constraintWithItem:cell
                                                                         attribute:NSLayoutAttributeBottomMargin
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:cell.itemDescription
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                          constant:10];
        [cell addConstraint:labelToButtom];
        
        return cell;
        
    }
}

#pragma mark -collection flowlayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] userShareItems] objectAtIndex:[indexPath row]];
    
    CGFloat labelHeight, imageHeight;
    
    NSArray *thumbnails = [[item thumbnailData] allKeys];
    if (thumbnails.count != 0) {
        labelHeight = [self labelHeight:item.itemDescription labelWidth:250 withTag:1];
        imageHeight = 100;
    } else {
        labelHeight = [self labelHeight:item.itemDescription labelWidth:250 withTag:0];
        imageHeight = 40;
    }
    
    return CGSizeMake(278, labelHeight + imageHeight);
}


/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    ZJFUserProfile *userProfile = [ZJFSNearlyItemStore shareStore].userProfile;
    
    NSString *userSignature = userProfile.userDescription;
    
    CGFloat labelHeight = [self labelHeight:userSignature labelWidth:204];
    
    NSLayoutConstraint *labelHeightConstraint = [NSLayoutConstraint constraintWithItem:headerView.userSignature
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1
                                                                    constant:labelHeight];
    [headerView.userSignature addConstraint:labelHeightConstraint];
    
    return CGSizeMake(320.0, labelHeight + 100);
    
}

 */

#pragma mark -页面跳转

- (IBAction)showImage:(id)sender {
    UIButton *button = (UIButton *)sender;
    buttonTag = button.tag;
    
    [self performSegueWithIdentifier:@"DetailPictureFromUserProfile" sender:sender];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"DetailPictureFromUserProfile"]) {
        ZJFUserProfileCC *cell = (ZJFUserProfileCC *)[sender getCollectionCellFromSubview];
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        
        ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] userShareItems] objectAtIndex:[indexPath row]];
        
        ZJFDetailPictureViewController *detialPictureVC = segue.destinationViewController;
        NSString *key = [[[item thumbnailData] allKeys] objectAtIndex:buttonTag];
        
        detialPictureVC.imageKey = key;
        detialPictureVC.imageStore = item.imageStore;
    } else if ([segue.identifier isEqualToString:@"ShowItemWithPictureFromUserProfile"]){
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] userShareItems] objectAtIndex:[indexPath row]];
        
        ZJFShowItemVC *showItemVC = segue.destinationViewController;
        showItemVC.item = item;
        showItemVC.headerButton.enabled = NO;  //从此页面跳转过去的不需要激活头像按钮
    } else if ([segue.identifier isEqualToString:@"ShowItemWithNoPictureFromUserProfile"]){
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] userShareItems] objectAtIndex:[indexPath row]];
        
        ZJFShowItemNoPictureVC *showItemVC = segue.destinationViewController;
        showItemVC.item = item;
        showItemVC.headerButton.enabled = NO;
    }
}


#pragma mark -关注举报功能
- (IBAction)followThisGuy:(id)sender {
    if (![AVUser currentUser]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"关注功能需要先登录再使用!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;

    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //关注此人
    UIAlertAction *followAction = [UIAlertAction actionWithTitle:@"关注Ta" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if ([[AVUser currentUser].username isEqualToString:userProfile.username]) {
            return;
        }
        
        AVObject *follow = [AVObject objectWithClassName:@"Follow"];
        [follow setObject:[AVUser currentUser].username forKey:@"from"];
        [follow setObject:userProfile.username forKey:@"to"];
        [follow saveInBackground];
        
    }];
    
    //举报此人
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报Ta" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UIAlertController *reportAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *reason1 = [UIAlertAction actionWithTitle:@"色情、政治等敏感信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
           
            [self reportUser:@"色情、政治等敏感信息"];
        }];
        
        UIAlertAction *reason2 = [UIAlertAction actionWithTitle:@"广告信息或骚扰用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self reportUser:@"广告信息或骚扰用户"];
        }];
        
        UIAlertAction *reason3 = [UIAlertAction actionWithTitle:@"侵权盗用行为" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self reportUser:@"侵权盗用行为"];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [reportAlert addAction:reason1];
        [reportAlert addAction:reason2];
        [reportAlert addAction:reason3];
        [reportAlert addAction:cancel];
        
        [self presentViewController:reportAlert animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:followAction];
    [alert addAction:reportAction];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)reportUser:(NSString *)reason{
    AVObject *report = [AVObject objectWithClassName:@"ReportUser"];
    [report setObject:[AVUser currentUser].username forKey:@"reporter"];
    [report setObject:userProfile.username forKey:@"reported"];
    [report setObject:reason forKey:@"reportReason"];
    [report saveInBackground];
    
    NSLog(@"举报成功\n");
}


#pragma mark -计算uilabel高度

- (CGFloat)labelHeight:(NSString *)string labelWidth:(float)width withTag:(int)tag{
    if (tag == 1) {
        //有图片，截150字符
        if (string.length > numberOfMaxCharacters) {
            string = [string substringToIndex:numberOfMaxCharacters];
        }
    } else {
        //无图片，截250字符
        if (string.length > numberOfMaxCharacters + 100) {
            string = [string substringToIndex:numberOfMaxCharacters + 100];
        }
    }
    
    
    string = [string stringByAppendingString:@"..."];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:15.0]
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:allRange];
    
    CGFloat titleHeight;
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    
    titleHeight = ceil(rect.size.height);
    
    return titleHeight + 2;  // 加两个像素,防止emoji被切掉.
}













@end
