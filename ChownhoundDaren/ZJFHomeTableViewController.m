//
//  ZJFHomeTableViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFHomeTableViewController.h"
#import "ZJFCurrentLocation.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ZJFHomeCell.h"
#import "ZJFCurrentUser.h"
#import "ZJFShowItemVC.h"
#import "ZJFDetailPictureViewController.h"
#import "ZJFSNearlyItemStore.h"
#import "ZJFShareItem.h"
#import "MJRefresh.h"
#import "ZJFProfileCollectionViewController.h"
#import "UIView+UIView_GetSuperView.h"
#import "ZJFHomeNoPictureCell.h"
#import "ZJFShowItemNoPictureVC.h"

static const double EARTH_ARC = 6367000;
static int numberOfMaxCharacters = 100; //如果评论超过50个字，在新页面查看详情

@interface ZJFHomeTableViewController ()
{
    double latitude;
    double longitude;
    int passItem;
    int buttonTag;  //点击照片时跳转的tag
}

@end

@implementation ZJFHomeTableViewController

- (void)viewDidLoad {
    //提供三种排序方式，由近到远，由远到近，乱序。。
    [super viewDidLoad];
    
    _locationManager = [[ZJFCurrentLocation shareStore] locationManager];  //开始定位
    
    [_locationManager setDelegate:self];
    [_locationManager requestWhenInUseAuthorization];
//    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [_locationManager startUpdatingLocation];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^(){
        [ZJFSNearlyItemStore shareStore].homeTableViewController = weakSelf;
        [[ZJFSNearlyItemStore shareStore] findSurroundObjectForRefresh];
    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^(){
        [ZJFSNearlyItemStore shareStore].homeTableViewController = weakSelf;
        [[ZJFSNearlyItemStore shareStore] findMoreObjectAfterRefresh];
    }];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (IBAction)refresh:(id)sender {
    [[ZJFSNearlyItemStore shareStore] findSurroundObjectForRefresh];
    [self.tableView reloadData];
}

#pragma mark -获取位置信息
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    static int hasUpdate = 0; //刷新10次后，停止刷新；
    CLLocation * location = [locations lastObject];
    [ZJFCurrentLocation shareStore].location = location;
    NSLog(@"1access location succeed!\n");
    hasUpdate++;
    
    if (hasUpdate == 10) {
        [_locationManager stopUpdatingLocation];
    }
    
}
    
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
        NSLog(@"error: %@\n",[error description]);
}

- (double)distanceBetween:(double)fromLatitude fromLongitude:(double)fromLongitude toLatitude:(double)toLatitude toLongitude:(double)toLongitude{
    return EARTH_ARC * acos(cos(fromLatitude * M_PI / 180) * cos(toLatitude * M_PI / 180) * cos((toLongitude - fromLongitude) * M_PI / 180) + sin(fromLatitude * M_PI/ 180) * sin(toLatitude *M_PI / 180));
}

#pragma mark -获取表格数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[ZJFSNearlyItemStore shareStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] allItems] objectAtIndex:[indexPath row]];
    
    NSArray *thumbnailKeys = [[item thumbnailData] allKeys];
    
    if ([thumbnailKeys count] != 0) {
        //这条信息包含图片
        ZJFHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellWithPicture"];
        
        if (!cell) {
            cell = [[ZJFHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeCellWithPicture"];
        }
        
        for (int i=0; i<[thumbnailKeys count]; i++) {
            //处理信息中包含的图片
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
        
        cell.nickName.text = item.nickName;
        
        UIImage *image = [UIImage imageWithData:item.headerImage scale:2.0];
        
  //      UIImage *headerImage = [self getThumbnail:image];
        
        [cell.headerImage setBackgroundImage:image forState:UIControlStateNormal];
        cell.headerImage.layer.cornerRadius = 26;
        cell.headerImage.clipsToBounds = YES;
        
        //如果字符超过100个字，则截取掉
        NSString *breifDescription = item.itemDescription;
        int length = breifDescription.length;
        
        if(length > numberOfMaxCharacters){
            breifDescription = [item.itemDescription substringToIndex:(numberOfMaxCharacters-3)];
            breifDescription = [breifDescription stringByAppendingString:@"..."];
            
        }
        
        cell.descriptionTextView.text = breifDescription;
        
        return  cell;
        
    } else{
        ZJFHomeNoPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellWithNoPicture"];
        if (!cell) {
            cell = [[ZJFHomeNoPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeCellWithNoPicture"];
        }
        
        cell.nickNameLabel.text = item.nickName;
        
        UIImage *image = [UIImage imageWithData:item.headerImage scale:2.0];
        
        UIImage *headerImage = [self getThumbnail:image];
        
        [cell.headerButton setBackgroundImage:headerImage forState:UIControlStateNormal];
        cell.headerButton.layer.cornerRadius = 26;
        cell.headerButton.clipsToBounds = YES;
        
        //如果字符超过100个字，则截取掉
        NSString *breifDescription = item.itemDescription;
        int length = breifDescription.length;
        
        if(length > numberOfMaxCharacters){
            breifDescription = [item.itemDescription substringToIndex:(numberOfMaxCharacters-3)];
            breifDescription = [breifDescription stringByAppendingString:@"..."];
            
        }
        
        cell.descriptionTextView.text = breifDescription;
        
        return  cell;

        
    }
    

}

#pragma mark -delegate 方法



#pragma mark -处理表格中的链接

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"DetailPicture"]) {
        ZJFHomeCell *cell = (ZJFHomeCell *)[sender getCellFromContentviewSubview];
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
        ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] allItems] objectAtIndex:[indexPath row]];

        NSLog(@"row: %d\n",[indexPath row]);
        
       ZJFDetailPictureViewController *detailPictureViewController = segue.destinationViewController;\
        
        NSString *key = [[[item thumbnailData] allKeys] objectAtIndex:buttonTag];
        
        detailPictureViewController.imageKey = key;
        detailPictureViewController.imageStore = item.imageStore;
        
    } else if ([segue.identifier isEqualToString:@"ShowProfile"]){
        ZJFHomeCell *cell = (ZJFHomeCell *)[sender getCellFromContentviewSubview];
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
        ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] allItems] objectAtIndex:[indexPath row]];
        
        NSLog(@"row: %d\n",[indexPath row]);
        
        ZJFProfileCollectionViewController *profileCollectionViewController = segue.destinationViewController;
        profileCollectionViewController.username = item.username;
        
        NSLog(@"item.username: %@\n",item.username);
    } else if ([segue.identifier isEqualToString:@"ShowItemWithPicture"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] allItems] objectAtIndex:[indexPath row]];
    
        ZJFShowItemVC *showItemVC = segue.destinationViewController;
        showItemVC.item = item;
    } else if ([segue.identifier isEqualToString:@"ShowItemWithNoPicture"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] allItems] objectAtIndex:[indexPath row]];
        
        ZJFShowItemNoPictureVC *showItemVC = segue.destinationViewController;
        showItemVC.item = item;
    }
    
}

- (IBAction)showImage:(id)sender {
    
    [self performSegueWithIdentifier:@"DetailPicture" sender:sender];
    
    UIButton *button = (UIButton *)sender;
    buttonTag = button.tag;
}
              
- (UIImage *)getThumbnail:(UIImage *)image{
    CGSize newSize = CGSizeMake(52, 52);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (IBAction)logout:(id)sender {
    [AVUser logOut];
    
    [ZJFCurrentUser shareCurrentUser].username = nil;
    [ZJFCurrentUser shareCurrentUser].nickName = nil;
    [ZJFCurrentUser shareCurrentUser].userDescription = nil;
    [ZJFCurrentUser shareCurrentUser].gender = nil;
    [ZJFCurrentUser shareCurrentUser].headerImage = nil;
    [ZJFCurrentUser shareCurrentUser].city = nil;
    
}









@end
