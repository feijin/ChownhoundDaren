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
#import "ZJFDetailPhotoViewController.h"

@interface ZJFCreateItemCollectionViewController ()

@property (nonatomic) NSMutableArray *capturedImages;
@property (nonatomic) UIImage *selectedImage;

@end

@implementation ZJFCreateItemCollectionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
   // self.capturedImages = [[NSMutableArray alloc] init];
    
    UIImage *image1 = [UIImage imageNamed:@"定位"];
    UIImage *image2 = [UIImage imageNamed:@"me"];
    
    self.capturedImages = [[NSMutableArray alloc] initWithObjects:image1,image2, nil];
    [self.collectionView reloadData];
    
//    NSLog(@"count = %d\n", [self.capturedImages count]);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.capturedImages count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"[index row] = %d\n",[indexPath row]);
    
    if ([indexPath row] == ([self.capturedImages count])) {
        ZJFCreateOfSpecialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateOfSpecialCell" forIndexPath:indexPath];
        
        return cell;
        
    } else {
        ZJFCreateOfPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateOfPhoto" forIndexPath:indexPath];
        
        [cell.imageView initWithImage:[self.capturedImages objectAtIndex:[indexPath row]]];

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



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedImage = [[self capturedImages] objectAtIndex:[indexPath row]];
    
    
}


@end
