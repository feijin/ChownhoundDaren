//
//  ZJFCreateItemCollectionViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/17.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFCreateItemCollectionViewController.h"
#import "ZJFCreateOfHeaderCollectionReusableView.h"
#import "ZJFCreateOfFooterCollectionReusableView.h"
#import "ZJFCreateOfPhotoCollectionViewCell.h"
#import "ZJFCreateOfSpecialCollectionViewCell.h"
#import "ZJFDetailOfCreateImageViewController.h"
#import "ZJFImageStore.h"
#import "ZJFImage.h"

@interface ZJFCreateItemCollectionViewController ()


@end

@implementation ZJFCreateItemCollectionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.capturedImages = [[NSMutableArray alloc] init];
    
   // [self.collectionView reloadData];
    
//    NSLog(@"count = %d\n", [self.capturedImages count]);
}

- (void)viewWillAppear:(BOOL)animated{
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    int maxNumberOfPictures = [self.capturedImages count]; //设定上传照片数量，五张
    
    if (maxNumberOfPictures >= 5) {
        return 5;
    } else {
        return [self.capturedImages count] + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"[index row] = %d\n",[indexPath row]);
    
    if ([indexPath row] == ([self.capturedImages count])) {
        ZJFCreateOfSpecialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateOfSpecialCell" forIndexPath:indexPath];
        
        return cell;
        
    } else {
        ZJFCreateOfPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateOfPhoto" forIndexPath:indexPath];
        ZJFImage *imageWithKey = [self.capturedImages objectAtIndex:[indexPath row]];
        
        [cell.imageView initWithImage:imageWithKey.image];

        return cell;

    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ZJFCreateOfHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CreateOfHeader" forIndexPath:indexPath];
        
        return header;
    } else {
        ZJFCreateOfFooterCollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CreateOfFooter" forIndexPath:indexPath];
        
        return footer;
    }
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
    
    ZJFImage *imageWithKey = [self.capturedImages objectAtIndex:[indexPath row]];
    
    ZJFDetailOfCreateImageViewController *detailOfCreateImageViewController = [segue destinationViewController];
    
    detailOfCreateImageViewController.imageWithKey = imageWithKey;
//    detailOfCreateImageViewController.captureImages = self.capturedImages;
    detailOfCreateImageViewController.createItemCollectionViewController = segue.sourceViewController;
    
    detailOfCreateImageViewController.hidesBottomBarWhenPushed = YES;
}


- (void)deleteImage:(ZJFImage *)imageWithKey{
    
    int row = [self.capturedImages indexOfObject:imageWithKey];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
   
   [self.capturedImages removeObject:imageWithKey];
    
    @try
    {
        [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    }
    @catch (NSException *except)
    {
        NSLog(@"  %@", except.description);
    }
    
//    [self.collectionView reloadData];  //切记要reloadData!!!
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == [self.capturedImages count]) {
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
                                                                  handler:^void(UIAlertAction *action){
                                                            
                                                                          
                                                                          UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                                                          imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
                                                                          imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                          imagePickerController.delegate = self;
                                                                          
                                                                          /*
                                                                           if (sourceType == UIImagePickerControllerSourceTypeCamera)
                                                                           {
                                                                           
                                                                           The user wants to use the camera interface. Set up our custom overlay view for the camera.
                                                                           
                                                                           imagePickerController.showsCameraControls = NO;
                                                                           
                                                                           Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
                                                                           
                                                                           [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
                                                                           self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
                                                                           imagePickerController.cameraOverlayView = self.overlayView;
                                                                           self.overlayView = nil;
                                                                           }
                                                                           */
                                                                          
                                                                          self.imagePickerController = imagePickerController;
                                                                          [self presentViewController:self.imagePickerController animated:YES completion:nil];

                                                                  }];
    
    UIAlertAction *chooseFromCamera = [UIAlertAction actionWithTitle:@"拍照"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    [alert addAction:chooseFromAlbumAction];
    [alert addAction:chooseFromCamera];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *uniqueImageName = [[NSUUID UUID] UUIDString];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    ZJFImage *imageWithKey = [[ZJFImage alloc] initWithImage:image key:uniqueImageName];
    
    [self.capturedImages addObject:imageWithKey];
    
//[[ZJFImageStore shareStore] setImage:image forKey:uniqueImageName];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}



















@end
