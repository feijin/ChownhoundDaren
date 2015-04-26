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

static int numberOfMaxCharacters = 150;

@interface ZJFProfileCollectionViewController (){

    ZJFShareItem *segueItem;
    ZJFUserProfileHeaderView *headerView; //保存header
    
}

@end


@implementation ZJFProfileCollectionViewController

@synthesize username;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[ZJFSNearlyItemStore shareStore] getProfile:username];
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
    
    [[ZJFSNearlyItemStore shareStore] clearUserShareItems];
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
    
    ZJFUserProfile *userProfile = [ZJFSNearlyItemStore shareStore].userProfile;
    
    header.headerImage.image = [UIImage imageWithData:userProfile.headerImage scale:2.0];
    header.headerImage.layer.cornerRadius = 31;
    header.headerImage.clipsToBounds = YES;
    
    header.userSignature.text = userProfile.userDescription;
    
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
        
        cell.itemDescription.text = item.itemDescription;
        
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
    
    CGFloat labelHeight = [self labelHeight:item.itemDescription labelWidth:250];
    
    CGFloat imageHeight;
    NSArray *thumbnails = [[item thumbnailData] allKeys];
    if (thumbnails.count == 0) {
        imageHeight = 40;
    } else {
        imageHeight = 80;
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


#pragma mark -计算uilabel高度

- (CGFloat)labelHeight:(NSString *)string labelWidth:(float)width{
    if (string.length > numberOfMaxCharacters) {
        string = [string substringToIndex:numberOfMaxCharacters];
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
