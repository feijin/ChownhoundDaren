//
//  ZJFCreateItemCollectionViewController.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/17.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJFImage;


@interface ZJFCreateItemCollectionViewController : UICollectionViewController
<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) NSMutableArray *capturedImages;
@property (nonatomic) UIImage *selectedImage;
@property (nonatomic) UIImagePickerController *imagePickerController;

- (void)showAlertSheet;
- (void)deleteImage:(ZJFImage *)imageWithKey;




@end
