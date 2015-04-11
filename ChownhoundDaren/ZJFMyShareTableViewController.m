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

static const int numberOfMaxCharacters = 50;

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
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^(){
        [[ZJFSNearlyItemStore shareStore] downloadMyShareItemForRefresh];
        [ZJFSNearlyItemStore shareStore].myShareTableViewController = weakSelf;
    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^(){
        [[ZJFSNearlyItemStore shareStore] downloadMyShareItemAfterRefresh];
        [ZJFSNearlyItemStore shareStore].myShareTableViewController = weakSelf;
    }];
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
    
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] myShareItems] objectAtIndex:[indexPath row]];
    
    cell.placeNameLabel.text = item.placeName;
    
    NSString *itemDescription = item.itemDescription;
    int length = itemDescription.length;
    
    NSString *breifDescription = itemDescription; //显示缩减的字符
    cell.moreDescriptionButton.hidden = YES;
    cell.moreDescriptionButton.enabled = NO;// 如果字符较少，不需要显示更多按钮
    
    if(length > numberOfMaxCharacters){
        //如果超过50个字符，截取47个字符
        breifDescription = [itemDescription substringToIndex:(numberOfMaxCharacters-3)];
        breifDescription = [breifDescription stringByAppendingString:@"..."];
        cell.moreDescriptionButton.hidden = NO;
        cell.moreDescriptionButton.enabled = YES;
    }
    
    
    [cell.itemDescriptionTextView setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    //   NSLog(@"font name: %@\n", cell.itemDescriptionTextView.font.fontName);
    
    cell.itemDescriptionTextView.text = breifDescription;
    
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
    [self performSegueWithIdentifier:@"ShowSharePicture" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowSharePicture"]) {
        ZJFDetailPictureViewController *detailPictureViewController = segue.destinationViewController;
        
        ZJFMyShareItemTableViewCell *cell = (ZJFMyShareItemTableViewCell *)[[sender superview] superview];
        
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
        
        NSLog(@"row: %d\n",[indexPath row]);
        
        ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] myShareItems] objectAtIndex:[indexPath row]];
        
        UIButton *button = (UIButton *)sender;
        
        NSString *key = [[[item thumbnailData] allKeys] objectAtIndex:button.tag];
        
        detailPictureViewController.imageKey = key;
        detailPictureViewController.imageStore = item.imageStore;
        
        return;
        
    }
}

@end
