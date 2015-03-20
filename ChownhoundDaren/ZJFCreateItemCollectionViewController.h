//
//  ZJFCreateItemCollectionViewController.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/17.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class ZJFCreateOfHeaderCollectionReusableView;
@class ZJFCreateOfFooterCollectionReusableView;


@interface ZJFCreateItemCollectionViewController : UICollectionViewController
<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate>


- (void)showAlertSheet;
- (void)deleteImage:(UIImage *)imageWithKey;
- (NSArray *)array;

- (ZJFCreateOfHeaderCollectionReusableView *)getHeaderView;
- (ZJFCreateOfFooterCollectionReusableView *)getFooterView;

- (IBAction)createCancel:(id)sender;
- (IBAction)sendToServe:(id)sender;



@end
