//
//  ZJFMyShareTableViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFMyShareTableViewController.h"
#import "ZJFShareItem.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ZJFCurrentUser.h"
#import "ZJFSNearlyItemStore.h"
#import "ZJFMyShareItemTableViewCell.h"
#import "ZJFDetailPictureViewController.h"

@interface ZJFMyShareTableViewController ()
<UIGestureRecognizerDelegate>
{
    NSArray *imageKeys;  //用于显示照片时传递
    NSString *imageKey;
}

@end

@implementation ZJFMyShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[ZJFSNearlyItemStore shareStore] myShareItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJFMyShareItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyShareItem"];
    
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] myShareItems] objectAtIndex:[indexPath row]];
    
    cell.placeNameLabel.text = item.placeName;
    cell.itemDescriptionTextView.text = item.itemDescription;
    
    if ([item.imagekeys count] != 0) {
        //这条信息包含图片
        
        //点击图片时可以查看大图的手势按钮
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
        
        
        for (int i=0; i<[item.imagekeys count]; i++) {
            switch (i) {
                case 0:{
                    UIImage *image = [item getThumbnailWithObjectId:[item.imagekeys objectAtIndex:0]];
                    //  NSLog(@"image width: %f, heigth: %f\n", image.size.width,image.size.height);
                    
                    cell.image1.image = image;
                    cell.image1.tag = 0;
                    [cell.image1 addGestureRecognizer:tap];
                    
                    // NSLog(@"image1 size wigth: %f, heigth: %f\n",cell.image1.image.size.width,cell.image1.image.size.height);
                    
                    cell.image2.image = nil;
                    cell.image3.image = nil;
                    break;
                }
                case 1:{
                    cell.image2.image = [item getThumbnailWithObjectId:[item.imagekeys objectAtIndex:1]];
                    cell.image2.tag = 1;
                    
                    [cell.image2 addGestureRecognizer:tap];
                    
                    cell.image3.image = nil;
                    break;
                }
                case 2:{
                    cell.image3.image = [item getThumbnailWithObjectId:[item.imagekeys objectAtIndex:2]];
                    cell.image3.tag = 2;
                    
                    [cell.image3 addGestureRecognizer:tap];
                    
                    break;
                }
                default:
                    break;
            }
            
        }
    } else {
        //此条信息不包含图片
        
        cell.image1.image = nil;
        cell.image2.image = nil;
        cell.image3.image = nil;
        
    }
    
    return cell;
}

- (void)showImage:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    ZJFMyShareItemTableViewCell *cell = (ZJFMyShareItemTableViewCell *)[[imageView superview] superview];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] myShareItems] objectAtIndex:[indexPath row]];
    
    imageKeys = [item imagekeys];
    imageKey = [imageKeys objectAtIndex:tap.view.tag];
    
    [self performSegueWithIdentifier:@"showMySharePicture" sender:tap.view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ZJFDetailPictureViewController *detailPictureViewController = segue.destinationViewController;
    detailPictureViewController.imageKeys = imageKeys;
    detailPictureViewController.imageKey = imageKey;
}

@end
