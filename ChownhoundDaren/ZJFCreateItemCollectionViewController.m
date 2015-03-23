//
//  ZJFCreateItemCollectionViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/17.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

#import "ZJFCreateItemCollectionViewController.h"
#import "ZJFCreateOfHeaderCollectionReusableView.h"
#import "ZJFCreateOfFooterCollectionReusableView.h"
#import "ZJFCreateOfPhotoCollectionViewCell.h"
#import "ZJFCreateOfSpecialCollectionViewCell.h"
#import "ZJFDetailOfCreateImageViewController.h"
#import "ZJFCurrentLocation.h"
#import "ZJFLoginViewController.h"
#import "AppDelegate.h"

@interface ZJFCreateItemCollectionViewController ()
{
    NSMutableDictionary *dictionary;  //存放header 和 footer 的引用
    CLLocationManager *locationManager;
    NSMutableArray *capturedImages;
 //   UIImagePickerController *imagePickerController;
}

@end

@implementation ZJFCreateItemCollectionViewController

int const numberOFMaxPictures = 5;

- (void)viewDidLoad{
    [super viewDidLoad];
    dictionary = [[NSMutableDictionary alloc] init];
    capturedImages = [[NSMutableArray alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.collectionView reloadData];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    if (self.loginViewController) {
        //检测到登录取消了，返回到首页
        if (self.loginViewController.isCancelLogin) {
            self.loginViewController = nil; //释放资源
            self.tabBarController.selectedIndex = 0;
        }
    } else{
        [self testLogin];
    }
}

- (void)testLogin{
    
    [AVUser logOut];
    AVUser *user = [AVUser currentUser];
    
    if (!user) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"111" message:@"www" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmLogin = [UIAlertAction actionWithTitle:@"登录"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^void(UIAlertAction *action){
                                                                 @try {
                            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            ZJFLoginViewController *loginController = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
                                                                     self.loginViewController = loginController;
                                                                     
                            [self presentViewController:loginController animated:YES completion:nil];
                                                                    
                            NSLog(@"111\n");
                            }
                                                                 @catch (NSException *exception) {
                                                                     NSLog(@"%@\n",exception);
                                                                     NSLog(@"222\n");
                                                                 }

                                                             }];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^void(UIAlertAction *action){
            self.tabBarController.selectedIndex = 0;
        }];
        
        [alert addAction:cancelButton];
        [alert addAction:confirmLogin];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [capturedImages count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath row] == ([capturedImages count])) {
        ZJFCreateOfSpecialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateOfSpecialCell" forIndexPath:indexPath];
        
        return cell;
        
    } else {
        ZJFCreateOfPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateOfPhoto" forIndexPath:indexPath];
        UIImage *imageWithKey = [capturedImages objectAtIndex:[indexPath row]];
        
        [cell.imageView initWithImage:imageWithKey];
        
        return cell;
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//执行两次
    
   
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ZJFCreateOfHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CreateOfHeader" forIndexPath:indexPath];
        
        [dictionary setObject:header forKey:@"header"];
        return header;
    } else {
        ZJFCreateOfFooterCollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CreateOfFooter" forIndexPath:indexPath];
        
        [dictionary setObject:footer forKey:@"footer"];
        return footer;
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
    
    UIImage *image = [capturedImages objectAtIndex:[indexPath row]];
    
    ZJFDetailOfCreateImageViewController *detailOfCreateImageViewController = [segue destinationViewController];
    
    detailOfCreateImageViewController.imageWithKey = image;
//    detailOfCreateImageViewController.captureImages = self.capturedImages;
    detailOfCreateImageViewController.createItemCollectionViewController = segue.sourceViewController;
    
    detailOfCreateImageViewController.hidesBottomBarWhenPushed = YES;
}


- (void)deleteImage:(UIImage *)image{
    
    int row = [capturedImages indexOfObject:image];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
   
   [capturedImages removeObject:image];
    
    
    @try
    {

        [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    }
    @catch (NSException *except)
    {
        NSLog(@"  %@", except.description);
    }
    
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == [capturedImages count]) {
        [self showAlertSheet];
    }
}

//设置新窗口，选择图片
- (void)showAlertSheet{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"nithing"
                                                                   message:@"选择照片上传方式"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *chooseFromAlbumAction = [UIAlertAction actionWithTitle:@"从相册选择"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler: ^void(UIAlertAction *action){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePickerController.delegate = self;
                                                                      
        imagePickerController = imagePickerController;
        [[self.tabBarController tabBar] setHidden:YES];
                                                                      
        [self presentViewController:imagePickerController animated:YES completion:nil];
                                                                      
                                                                  }];

    
    UIAlertAction *chooseFromCamera = [UIAlertAction actionWithTitle:@"拍照"
                                                               style:UIAlertActionStyleDefault
                                                             handler: ^void(UIAlertAction *action){
         UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
         imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
         imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
         imagePickerController.delegate = self;
                                                                 
         imagePickerController = imagePickerController;
         [[self.tabBarController tabBar] setHidden:YES];
                                                                 
         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                                                        
         [self presentViewController:imagePickerController animated:YES completion:nil];
                                                                 
                                                             }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:chooseFromAlbumAction];
    [alert addAction:chooseFromCamera];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    [capturedImages addObject:image];
        
    //[[ZJFImageStore shareStore] setImage:image forKey:uniqueImageName];
        
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self.tabBarController tabBar] setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
        
}

- (NSArray *)array{
    return capturedImages;
}

- (ZJFCreateOfHeaderCollectionReusableView *)getHeaderView{
    return [dictionary objectForKey:@"header"];
}

- (ZJFCreateOfFooterCollectionReusableView *)getFooterView{
    return [dictionary objectForKey:@"footer"];
}

- (IBAction)createCancel:(id)sender {
    
}

- (IBAction)sendToServe:(id)sender {
    [[[ZJFCurrentLocation shareStore] locationManager] stopUpdatingLocation];
    
    //   CLLocation *xlocation = [ZJFCurrentLocation shareStore].location;
    //   NSLog(@"fuck1: %f\n",xlocation.coordinate.latitude);
    //   NSLog(@"fuck2: %f\n",xlocation.coordinate.longitude);
    //  NSLog(@"fuck3:%@\n",xlocation.description);
    
    CLLocation *cllocation = [ZJFCurrentLocation shareStore].location;
    
    AVObject *shareItem = [AVObject objectWithClassName:@"shareItem"];
    
    AVObject *location = [AVObject objectWithClassName:@"location"];
    [location setObject:[NSNumber numberWithDouble:cllocation.coordinate.latitude] forKey:@"latitude"];
    [location setObject:[NSNumber numberWithDouble:cllocation.coordinate.longitude] forKey:@"longitude"];
    [location setObject:[NSNumber numberWithDouble:cllocation.altitude] forKey:@"altitude"];
    [location setObject:[NSNumber numberWithInteger:cllocation.floor] forKey:@"floor"];
    [location setObject:[NSNumber numberWithDouble:cllocation.horizontalAccuracy] forKey:@"horizontalAccuracy"];
    [location setObject:[NSNumber numberWithDouble:cllocation.verticalAccuracy] forKey:@"verticalAccuracy"];
    [location setObject:cllocation.timestamp forKey:@"timestamp"];
    [location setObject:cllocation.description forKey:@"descriptionOfLocation"];
    [shareItem setObject:location forKey:@"locationOfItem"];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[capturedImages count]; i++) {
        NSString *string = [@"image" stringByAppendingString:[NSString stringWithFormat:@"%d",(i+1)]];
    //    NSLog(@"%@\n",string);
        NSData *data = UIImagePNGRepresentation([capturedImages objectAtIndex:i]);
        AVFile *file = [AVFile fileWithName:string data:data];
        [file save];
        
        [mutableArray addObject:file];
    }
    
    [shareItem setObject:(NSArray *)mutableArray forKey:@"imageStore"];
    
    NSString *descriptionOfItem = [[self getHeaderView] textViewInHeader].text;     //描述信息
//    NSLog(@"%@\n",descriptionOfItem);
    
    NSString *locationNameOfItem = [[self getFooterView] textFieldInFooter].text; //给位置命名
//    NSLog(@"%@\n",locationNameOfItem);
    
   
    [shareItem setObject:descriptionOfItem forKey:@"descriptionOfItem"];
    [shareItem setObject:locationNameOfItem forKey:@"locationNameOfItem"];
    
    
    [shareItem setObject:@"15202150609" forKey:@"userID"];
    
    
    [shareItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!error) {
            NSLog(@"保存完成\n");
        } else {
            NSLog(@"%@\n",[error description]);
        }
    }];
    
}

















@end
