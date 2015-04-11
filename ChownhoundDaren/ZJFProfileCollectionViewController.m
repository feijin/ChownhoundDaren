//
//  ZJFProfileCollectionViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/10.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFProfileCollectionViewController.h"
#import "ZJFUserProfileCollectionViewCell.h"
#import "ZJFSNearlyItemStore.h"
#import "ZJFShareItem.h"
#import "ZJFUserProfileHeaderView.h"
#import "ZJFUserProfile.h"
#import "MJRefresh.h"

static int numberOfMaxCharacters = 100;

@implementation ZJFProfileCollectionViewController

@synthesize username;

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    [self.collectionView registerClass:[ZJFUserProfileCollectionViewCell class] forCellWithReuseIdentifier:@"ProfileCollectionCell"];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //清除他人信息
    [ZJFSNearlyItemStore shareStore].userProfile = nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[ZJFSNearlyItemStore shareStore] userShareItems] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZJFUserProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCollectionCell" forIndexPath:indexPath];
    
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] userShareItems] objectAtIndex:[indexPath row]];
    
    NSArray *thumbnailKeys = [[item thumbnailData] allKeys];
    
    if ([thumbnailKeys count] != 0) {
        //这条信息包含图片
        
        //点击图片时可以查看大图的手势按钮
        
        for (int i=0; i<[thumbnailKeys count]; i++) {
            switch (i) {
                case 0:{
                    NSData *imageData = [[item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                    UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                    
                    cell.image1.image = image;
                    cell.image1.tag = 0;
                    
                    cell.button1.enabled = YES;
                    cell.button2.enabled = NO;
                    cell.button3.enabled = NO;
                    
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
                    
                    cell.button2.enabled = YES;
                    
                    cell.image3.image = nil;
                    break;
                }
                case 2:{
                    NSData *imageData = [[item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                    UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                    
                    cell.image3.image = image;
                    cell.image3.tag = 2;
                    
                    cell.button3.enabled = YES;
                    
                    break;
                }
                default:
                    break;
            }
            
        }
    } else {
        //此条信息不包含图片
        
        cell.image1.image = nil;
        cell.image2.image = nil;
        cell.image3.image = nil;
        
        cell.button1.enabled = NO;
        cell.button2.enabled = NO;
        cell.button3.enabled = NO;
        
        
    }
    
    NSString *itemDescription = item.itemDescription;
    int length = itemDescription.length;
    
    NSString *breifDescription = itemDescription; //显示缩减的字符
    
    if(length > numberOfMaxCharacters){
        //如果超过50个字符，截取47个字符
        breifDescription = [itemDescription substringToIndex:(numberOfMaxCharacters-3)];
        breifDescription = [breifDescription stringByAppendingString:@"..."];
        
    }
    
    cell.descriptionTextView.text = breifDescription;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ZJFUserProfileHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileHeader" forIndexPath:indexPath];
    
    ZJFUserProfile *profile = [ZJFSNearlyItemStore shareStore].userProfile;
    
    header.nickNameLabel.text = profile.nickName;
    header.genderImageView.image = [UIImage imageNamed:profile.gender];
    header.cityLabel.text = profile.city;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yy-MM-dd";
    header.joinDate.text = [formatter stringFromDate:profile.joinDate];
    
    header.userDescriptionTextView.text = profile.userDescription;
    
    return header;
    
}




@end
