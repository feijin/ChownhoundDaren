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
#import "ZJFHomeTableViewCell.h"
#import "ZJFCurrentUser.h"
#import "ZJFMoreDescriptionViewController.h"
#import "ZJFDetailPictureViewController.h"
#import "ZJFSNearlyItemStore.h"
#import "ZJFShareItem.h"

static const double EARTH_ARC = 6367000;
static int numberOfMaxCharacters = 50; //如果评论超过50个字，在新页面查看详情

@interface ZJFHomeTableViewController ()
{
    double latitude;
    double longitude;
    int passItem;
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

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    if ([[ZJFSNearlyItemStore shareStore] allItems] != 0) {
        return [[ZJFSNearlyItemStore shareStore] allItems].count;
    } else {
        return 1;
    } 
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] allItems] objectAtIndex:[indexPath row]];
    
    ZJFHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    if (cell == nil) {
        cell = [[ZJFHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeCell"];
    }
    
    NSArray *thumbnailKeys = [[item thumbnailData] allKeys];
    
    if ([thumbnailKeys count] != 0) {
        //这条信息包含图片
        
        //点击图片时可以查看大图的手势按钮
        
        for (int i=0; i<[thumbnailKeys count]; i++) {
            switch (i) {
                case 0:{
                    NSData *imageData = [[item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                    UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                    //NSLog(@"image width: %f, height: %f\n",image.size.width,image.size.height);
                    
                    cell.image1.image = image;
                    cell.image1.tag = 1;
                    cell.button1.enabled = YES;
                    cell.button1.hidden = NO;
                    
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
                    cell.image2.tag = 2;
                    
                    cell.button2.enabled = YES;
                    cell.button2.hidden = NO;
                    cell.image3.image = nil;
                    break;
                }
                case 2:{
                    NSData *imageData = [[item thumbnailData] objectForKey:[thumbnailKeys objectAtIndex:i]];
                    UIImage *image = [UIImage imageWithData:imageData scale:2.0];
                    
                    cell.image3.image = image;
                    cell.image3.tag = 3;
                    
                    cell.button3.enabled = YES;
                    cell.button3.hidden = NO;
                    
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
    cell.placeName.text = item.placeName;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //设置选中时没有效果
    
    if(item.nickName == nil)
        cell.nickNameButton.titleLabel.text = @"匿名";
    else
        cell.nickNameButton.titleLabel.text = item.nickName;
    
//    cell.dateLabel.text = item.createDate;
    
    cell.placeName.text = item.placeName;
    
    cell.prasiceNumber.text = [NSString stringWithFormat:@"%d",[[item prasice] count]];
    
    int distance = [self distanceBetween:[[ZJFCurrentLocation shareStore] location].coordinate.latitude fromLongitude:[[ZJFCurrentLocation shareStore] location].coordinate.longitude  toLatitude:item.latitude toLongitude:item.longitude];
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"%dm",distance];
    
    
    return cell;
}

- (IBAction)refresh:(id)sender {
    [[ZJFSNearlyItemStore shareStore] findSurroundObjectForRefresh];
    
    [self.tableView reloadData];
}


#pragma mark -处理表格中的链接

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"DetailPicture"]) {
       ZJFDetailPictureViewController *detailPictureViewController = segue.destinationViewController;
        
        ZJFHomeTableViewCell *cell = (ZJFHomeTableViewCell *)[[sender superview] superview];
        
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
        
        NSLog(@"row: %d\n",[indexPath row]);
        
        ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] allItems] objectAtIndex:[indexPath row]];
        
        UIButton *button = (UIButton *)sender;
        
        NSString *key = [[[item thumbnailData] allKeys] objectAtIndex:button.tag];
        
        detailPictureViewController.imageKey = key;
        detailPictureViewController.imageStore = item.imageStore;
        
        return;
        
    } else if([segue.identifier isEqualToString:@"MoreDescription"]){
        ZJFMoreDescriptionViewController *moreDescriptionViewController = segue.destinationViewController;
        ZJFHomeTableViewCell *cell = (ZJFHomeTableViewCell *)[[sender superview] superview];
        
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
        
        ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] allItems] objectAtIndex:[indexPath row]];
        moreDescriptionViewController.item = item;
    }
    
    
}

- (IBAction)showImage:(id)sender {
    [self performSegueWithIdentifier:@"DetailPicture" sender:sender];
}

              
              
              
















@end
