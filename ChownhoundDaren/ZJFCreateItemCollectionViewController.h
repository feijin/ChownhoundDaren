//
//  ZJFCreateItemCollectionViewController.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/17.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class ZJFImage;
@class ZJFShareItem;
@class ZJFCreateOfHeaderCollectionReusableView;
@class ZJFCreateOfFooterCollectionReusableView;


@interface ZJFCreateItemCollectionViewController : UICollectionViewController
<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    ZJFShareItem *item;
    CLLocationManager *locationManager;
    NSMutableDictionary *dictionary;  //存放header 和 footer 的引用
}

@property (nonatomic) NSMutableArray *capturedImages;
@property (nonatomic) UIImage *selectedImage;
@property (nonatomic) UIImagePickerController *imagePickerController;



- (void)showAlertSheet;
- (void)deleteImage:(ZJFImage *)imageWithKey;
- (ZJFCreateOfHeaderCollectionReusableView *)getHeader;
- (ZJFCreateOfFooterCollectionReusableView *)getFooter;

- (IBAction)sendToServe:(id)sender;



@end
