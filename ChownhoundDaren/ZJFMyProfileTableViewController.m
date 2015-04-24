//
//  ZJFMyProfileTableViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/24.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFMyProfileTableViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ZJFCurrentUser.h"
#import "RSKImageCropViewController.h"
#import "ZJFLoginViewController.h"
#import "ZJFMyShareTableViewController.h"

@interface ZJFMyProfileTableViewController()
<UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;




@end

@implementation ZJFMyProfileTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[self.tabBarController tabBar] setHidden:NO];
    
    if ([[ZJFCurrentUser shareCurrentUser] isLogin]) {
        [self.tableView setAllowsSelection:YES];
        
        self.loginButton.enabled = NO;
        self.loginButton.hidden = YES;
        
        //载入头像
        NSData *headerData = [ZJFCurrentUser shareCurrentUser].headerImage;
        UIImage *image = [UIImage imageWithData:headerData scale:2.0];
        if (!image) {
            [self.headerButton setBackgroundImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
        } else {
            [self.headerButton setBackgroundImage:image forState:UIControlStateNormal];
        }
        
        self.headerButton.layer.cornerRadius = 41;
        self.headerButton.clipsToBounds = YES;
        
        if (![ZJFCurrentUser shareCurrentUser].nickName) {
            self.nickNameLabel.text = @"匿名";
        } else {
            self.nickNameLabel.text = [ZJFCurrentUser shareCurrentUser].nickName;
        }
        
        self.signatureLabel.text = [ZJFCurrentUser shareCurrentUser].userDescription;
    } else {
        [self.tableView setAllowsSelection:NO];
        
        [self.headerButton setBackgroundImage:nil forState:UIControlStateNormal];
        self.nickNameLabel.text = nil;
        self.signatureLabel.text = nil;
        
        //显示登录按钮
        self.loginButton.enabled = YES;
        self.loginButton.hidden = NO;
        
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)setCellEnable:(BOOL)enable{
    //未登录时前三个表格行禁止选择
    
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path1];
    cell.userInteractionEnabled = enable;
    
    NSIndexPath *path2 = [NSIndexPath indexPathForRow:0 inSection:1];
    UITableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:path2];
    cell2.userInteractionEnabled = enable;
    
    NSIndexPath *path3 = [NSIndexPath indexPathForRow:1 inSection:1];
    UITableViewCell *cell3 = [self.tableView cellForRowAtIndexPath:path3];
    cell3.userInteractionEnabled = enable;
}

#pragma mark -tableviewdelegate


#pragma mark -处理个人头像
- (IBAction)setHeaderImage:(id)sender {
    //点击头像后，选择更改头像方式
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *chooseFromCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        
        [[self.tabBarController tabBar] setHidden:YES];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *chooseFromAlbum = [UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        
        [[self.tabBarController tabBar] setHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:chooseFromCamera];
    [alert addAction:chooseFromAlbum];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //得到图片后，交由imageCropVc剪切出圆形头像
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    imageCropVC.delegate = self;
    
    [self.navigationController pushViewController:imageCropVC animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[self.tabBarController tabBar] setHidden:NO];
    
    
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller{
    [self.navigationController popViewControllerAnimated:YES];
    [[self.tabBarController tabBar] setHidden:NO];

}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect{
    
    
    //得到圆形头像的缩略图，目的是减少大小
    UIImage *image = [self getThumbnail:croppedImage];
    
    //将圆形头像的data数据保存至服务器
    NSData *headerData = UIImageJPEGRepresentation(image, 0.5); //小头像
    
    NSData *headerBigData = UIImageJPEGRepresentation(croppedImage, 1.0);  //大头像
    AVFile *file = [AVFile fileWithData:headerBigData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded){
            NSLog(@"大头像保存成功！\n");
        }
    }];
    
    //先找出当前用户的信息存储对象
    AVQuery *query = [AVQuery queryWithClassName:@"userInformation"];
    [query whereKey:@"username" equalTo:[AVUser currentUser].username];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error){
        if(!error){
            [object setObject:headerData forKey:@"headerData"];
            [object setObject:file forKey:@"headerBigData"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                
                if (succeeded) {
                    NSLog(@"更新头像信息成功！\n");
                }else{
                    NSLog(@"更新头像信息失败：%@\n", error);
                }
            }];
        } else{
            NSLog(@"查找用户 error: %@\n", [error description]);
        }
    }];
    
    
    [ZJFCurrentUser shareCurrentUser].headerImage = headerData;
    [self.navigationController popViewControllerAnimated:YES];
    [[self.tabBarController tabBar] setHidden:NO];

    
}

- (UIImage *)getThumbnail:(UIImage *)image{
    CGSize newSize = CGSizeMake(82, 82);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark -处理页面跳转

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
}






@end
