//
//  ZJFDetailPictureViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/31.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFDetailPictureViewController.h"


@interface ZJFDetailPictureViewController ()
<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end



@implementation ZJFDetailPictureViewController


- (void)viewDidLoad{
    if (_imageId == [_imageStore count]) {
        _imageId = [_imageStore count] - 1;
    }
    self.imageView.image = [_imageStore objectAtIndex:_imageId];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenImage:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)hiddenImage:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
