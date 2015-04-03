//
//  ZJFDetailPictureViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/31.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFDetailPictureViewController.h"
#import "ZJFImageStore.h"


@interface ZJFDetailPictureViewController ()
<UIGestureRecognizerDelegate>
{
    NSDictionary *imageStore;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end



@implementation ZJFDetailPictureViewController

@synthesize imageKeys,imageKey;

- (void)viewDidLoad{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenImage:)];
    [self.view addGestureRecognizer:tap];
    
    imageStore = [[ZJFImageStore shareStore] imageForKeys:imageKeys];
    self.imageView.image = [imageStore objectForKey:imageKey];
    
}

- (void)hiddenImage:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
