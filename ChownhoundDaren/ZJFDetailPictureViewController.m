//
//  ZJFDetailPictureViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/31.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFDetailPictureViewController.h"
#import "ZJFImageStore.h"
#import <AVOSCloud/AVOSCloud.h>


@interface ZJFDetailPictureViewController ()
<UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *processLabel;

@end



@implementation ZJFDetailPictureViewController

@synthesize imageKey,imageStore,image;

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    image = [[ZJFImageStore shareStore] imageForKey:imageKey];
    
    if (image) {
        self.imageView.image = image;
        self.processLabel.text = @"";
    } else {
        NSArray *allKey = [imageStore allKeys];
        for (NSString *fileId in allKey) {
            [AVFile getFileWithObjectId:fileId withBlock:^(AVFile *file, NSError *error){
                if (!error) {
                    NSLog(@"get file succeeded!\n");

                    if ([file.name isEqualToString:imageKey]){
                        __weak __typeof__(self) weakSelf = self;
                        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                            if (!error) {
                                NSLog(@"get data succeed!\n");
                                weakSelf.imageView.image = [UIImage imageWithData:data];
                                [[ZJFImageStore shareStore] setImage:[UIImage imageWithData:data] forKey:imageKey];
                            } else{
                                NSLog(@"get data fial: %@\n", [error description]);
                            }
                        }progressBlock:^(NSInteger percentge){
                            double percent = percentge / 100.0;
                            weakSelf.processLabel.text = [NSString stringWithFormat:@"已下载：%.2f",percent];
                                
                        }];
                       
                    }
                    
                }else {
                    NSLog(@"get file fail: %@\n", [error description]);
                }
                    
            }];
        }
        
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenImage:)];
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipeGesture1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeftImage:)];
    [swipeGesture1 setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeGesture1];
    
    UISwipeGestureRecognizer *swipeGesture2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showRightImage:)];
    [swipeGesture2 setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGesture2];

}

- (void)showLeftImage:(UISwipeGestureRecognizer *)swipe{
    NSLog(@"swipe to right\n");
    
    NSArray *keys = [imageStore allValues];
    int i = [keys indexOfObject:imageKey];
    if (i != 0) {
        imageKey = [keys objectAtIndex:(i-1)];
    }
   
    [self viewWillAppear:YES];
}

- (void)showRightImage:(UISwipeGestureRecognizer *)swipe{
    NSLog(@"swipe to left\n");
    
    NSArray *keys = [imageStore allValues];
    int i = [keys indexOfObject:imageKey];
    
    if (i != ([keys count] - 1)) {
        imageKey = [keys objectAtIndex:(i + 1)];
    }
    
    [self viewWillAppear:YES];
}

- (void)hiddenImage:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
