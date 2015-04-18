//
//  ZJFMyProfileTableViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/24.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFMyProfileTableViewController.h"
#import "ZJFMyProfileTableViewCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ZJFCurrentUser.h"
#import "RSKImageCropViewController.h"
#import "ZJFLoginViewController.h"

@interface ZJFMyProfileTableViewController()
<UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate>

@end

@implementation ZJFMyProfileTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([AVUser currentUser] == nil) {
        [self showLogin];
    }
    
    [self.tableView reloadData];
}


#pragma mark -tableview信息
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 2;
    } else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section]==0) {
        ZJFMyProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileFirstCell"];
        NSLog(@"nickname: %@\n",[[ZJFCurrentUser shareCurrentUser] nickName]);
        cell.nickNameLabel.text = [[ZJFCurrentUser shareCurrentUser] nickName];
        
        NSData *headerData = [ZJFCurrentUser shareCurrentUser].headerImage;
        UIImage *headerImage = [UIImage imageWithData:headerData];
        
        if (headerImage != nil) {
            cell.headerView.image = headerImage;
            cell.headerView.layer.cornerRadius = 41;
            cell.headerView.clipsToBounds = YES;
            
        } else{
            cell.headerView.image = [UIImage imageNamed:@"touxiang"];
        }
        
        if ([[ZJFCurrentUser shareCurrentUser] userDescription]) {
            cell.signature.text = [[ZJFCurrentUser shareCurrentUser] userDescription];
        } else{
            cell.signature.text = @"";
        }
        
        return cell;
    } else if([indexPath section]==1) {
        ZJFMyProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileSecondCell"];
        if ([indexPath row]==0) {
            cell.labelOfShares.text = @"我的分享";
            cell.imageViewOfShares.image = [UIImage imageNamed:@"fenxiang1"];
            return cell;
        } else{
            cell.labelOfShares.text = @"我的互动";
            cell.imageViewOfShares.image = [UIImage imageNamed:@"zanyang1"];
            return cell;
        }
    }else{
        ZJFMyProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileSecondCell"];
        cell.labelOfShares.text = @"设置";
        cell.imageViewOfShares.image = [UIImage imageNamed:@"shezhi1"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section]==0) {
        return 100.f;
    }else{
        return 62.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}

#pragma mark -tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section] == 0) {
        [self performSegueWithIdentifier:@"ShowProfile" sender:indexPath];
    }else if([indexPath section] == 1 && [indexPath row] == 0){
        [self performSegueWithIdentifier:@"ShowMyShare" sender:self];
    }else if ([indexPath section] == 2){
        [self performSegueWithIdentifier:@"ShowSettingPage" sender:indexPath];
    }
}

#pragma mark -设置页面跳转



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
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect{
    
    UIImage *image = [self getThumbnail:croppedImage];
    
    //将圆形头像的data数据保存至服务器
    NSData *headerData = UIImageJPEGRepresentation(image, 0.5); //小头像
    
    NSData *headerBigData = UIImageJPEGRepresentation(croppedImage, 1.0);  //大头像
    AVFile *file = [AVFile fileWithData:headerBigData];
    [file saveInBackground];
    
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
    
}

- (UIImage *)getThumbnail:(UIImage *)image{
    CGSize newSize = CGSizeMake(82, 82);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark -检测是否登录，如未登录则给出登录界面

- (void)showLogin{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"尚未登录" message:@"点击确定登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmLogin = [UIAlertAction actionWithTitle:@"登录"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^void(UIAlertAction *action){
                                                             [self performSegueWithIdentifier:@"ShowLogin" sender:self];
                                                             
                                                         }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^void(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
        self.tabBarController.selectedIndex = 0;
    }];
    
    [alert addAction:cancelButton];
    [alert addAction:confirmLogin];
    
    [self presentViewController:alert animated:YES completion:nil];
}




@end
