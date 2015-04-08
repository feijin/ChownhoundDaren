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
#import "MJRefresh.h"

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[ZJFSNearlyItemStore shareStore] myShareItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJFMyShareItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyShareItem"];
    if (cell == nil) {
        cell = [[ZJFMyShareItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyShareItem"];
    }
    
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] myShareItems] objectAtIndex:[indexPath row]];
    
    cell.placeNameLabel.text = item.placeName;
    cell.itemDescriptionTextView.text = item.itemDescription;
    
    NSArray *thumbnailKeys = [[item thumbnailData] allKeys];
    
    if ([thumbnailKeys count] != 0) {
        //这条信息包含图片
        
        //点击图片时可以查看大图的手势按钮
        
        for (int i=0; i<[thumbnailKeys count]; i++) {
            switch (i) {
                case 0:{
                    NSData *imageData = [[item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                    UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                    
                    cell.image1.image = image;
                    cell.image1.tag = 0;
                    
                    cell.button1.enabled = YES;
                    cell.button2.enabled = NO;
                    cell.button3.enabled = NO;
                    
                    // NSLog(@"image1 size wigth: %f, heigth: %f\n",cell.image1.image.size.width,cell.image1.image.size.height);
                    
                    cell.image2.image = nil;
                    cell.image3.image = nil;
                    break;
                }
                case 1:{
                    NSData *imageData = [[item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                    UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                    
                    cell.image2.image = image;
                    cell.image2.tag = 1;
                    
                    cell.button2.enabled = YES;
                    
                    cell.image3.image = nil;
                    break;
                }
                case 2:{
                    NSData *imageData = [[item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                    UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                    
                    cell.image3.image = image;
                    cell.image3.tag = 2;
                    
                    cell.button3.enabled = YES;
                    
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
        
        cell.button1.enabled = NO;
        cell.button2.enabled = NO;
        cell.button3.enabled = NO;
        
        
    }
    
    return cell;
}

- (IBAction)showImage:(id)sender {
    ZJFMyShareItemTableViewCell *cell = (ZJFMyShareItemTableViewCell *)[[sender superview] superview];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] myShareItems] objectAtIndex:[indexPath row]];
   
    UIButton *button = (UIButton *)sender;
    
    imageKeys = [item imageStore];
    imageKey = [imageKeys objectAtIndex:button.tag];
    
    [self performSegueWithIdentifier:@"ShowMySharePicture" sender:sender];
}

@end
