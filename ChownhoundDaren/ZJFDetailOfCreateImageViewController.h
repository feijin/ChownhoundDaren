//
//  ZJFDetailOfCreateImageViewController.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/18.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJFCreateItemCollectionViewController;


@interface ZJFDetailOfCreateImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) UIImage *imageWithKey;
@property (nonatomic,assign) ZJFCreateItemCollectionViewController *createItemCollectionViewController;
@property (nonatomic) NSMutableArray *capturedImages;

- (IBAction)deleteImage:(id)sender;
- (IBAction)hideNavigationBar:(id)sender;

@end
