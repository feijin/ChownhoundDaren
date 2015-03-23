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
@class ZJFLoginViewController;


@interface ZJFCreateItemCollectionViewController : UICollectionViewController
<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    
}

@property (nonatomic,strong) ZJFLoginViewController *loginViewController;

- (void)showAlertSheet;
- (void)deleteImage:(UIImage *)imageWithKey;
- (NSArray *)array;

- (ZJFCreateOfHeaderCollectionReusableView *)getHeaderView;
- (ZJFCreateOfFooterCollectionReusableView *)getFooterView;
- (void)testLogin;

- (IBAction)createCancel:(id)sender;
- (IBAction)sendToServe:(id)sender;



@end
