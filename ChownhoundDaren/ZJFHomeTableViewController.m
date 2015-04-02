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
    [_locationManager startUpdatingLocation];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
}

#pragma mark -获取位置信息
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation * location = [locations lastObject];
    
   
    
    [ZJFCurrentLocation shareStore].location = location;
    longitude = location.coordinate.longitude;
    latitude = location.coordinate.latitude;
    
    static int hasRefresh = 0;  //表示是否刷新过，如果已刷新，则后面接收到的新位置，不再重复寻找周边信息。
    
    // 第一次得到的位置可能不太准确，为保持准确度，采取第2个接受的位置作为当前位置
    if (hasRefresh == 1) {
        [_locationManager stopUpdatingLocation];
        
         NSLog(@"access location succeed!\n");
        [self viewWillAppear:YES];
    }
    
    hasRefresh++;

    
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
    
    if ([indexPath row] == 0 && [[ZJFSNearlyItemStore shareStore] allItems].count == 0) {
        ZJFHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
        cell.descriptionTextView.text = @"周围暂没有数据，去发布美食信息吧";
        return cell;
    }
    
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] allItems] objectAtIndex:[indexPath row]];
    
    ZJFHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    
    cell.descriptionTextView.text = item.itemDescription;
    return cell;
    
/*
    
    if ([imageStoreData count] != 0) {
        //根据是否包含图片，选择相应的cell
        
        for (int i=0;i<[imageStoreData count];i++) {
            NSLog(@"imageStoreData = %lu\n",(unsigned long)[imageStoreData count]);
            AVFile *file = [imageStoreData objectAtIndex:i];
            
            [file getThumbnail:YES width:63 height:60 withBlock:^(UIImage *image, NSError *error){
                if (!error) {
                    [imageArray addObject:image];
                } else {
                    NSLog(@"error: %@\n",[error description]);
                }
            }];
            
            NSLog(@"imageArray count = %d\n",[imageArray count]);
        }
        
        NSLog(@" count = %d\n",[imageArray count]);
        
        ZJFHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
        cell.imageStore = (NSArray *)imageArray;   //为每个cell存储相应图片数组
        
        for (int i=0; i<[imageArray count]; i++) {
            switch (i) {
                case 0:{
                    cell.image1.image = [imageArray objectAtIndex:i];
                    cell.image1.tag = 1;
                    
                    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
                    [cell.image1 addGestureRecognizer:tap1];
                    break;
                }
                case 1:{
                    cell.image2.image = [imageArray objectAtIndex:i];
                    cell.image2.tag = 2;
                    
                    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
                    [cell.image2 addGestureRecognizer:tap2];
                    break;
                }
                case 2:{
                    cell.image3.image = [imageArray objectAtIndex:i];
                    cell.image3.tag = 3;
                    
                    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
                    [cell.image3 addGestureRecognizer:tap3];
                    break;
                }
                default:
                    break;
            }
        }
        
        NSString *itemDescription = [item objectForKey:@"itemDescription"];
        
        int length = itemDescription.length;
        
        NSString *description = itemDescription;
        
        cell.moreDescription.hidden = YES; // 如果字符较少，不需要显示更多信息
        
        if(length > numberOfMaxCharacters){
            //如果超过50个字符，截取47个字符
            description = [itemDescription substringToIndex:(numberOfMaxCharacters-3)];
            description = [description stringByAppendingString:@"..."];
            cell.moreDescription.hidden = NO;
        }
        
        
        [cell.descriptionTextView setFont:[UIFont fontWithName:@"Helvetica" size:16]];
//        NSLog(@"font name: %@\n", cell.descriptionTextView.font.fontName);
        
        cell.descriptionTextView.text = description;
        cell.placeName.text = [item objectForKey:@"placeName"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  //设置选中时没有效果
        
        return cell;

        
    } else {
        ZJFHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellNoPicture"];
        
        NSString *description = [item objectForKey:@"itemDescription"];
        int length = description.length;
        
        [cell.descriptionTextView setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        cell.descriptionTextView.text = description;
        
        return cell;

    }
 */
    
}

- (IBAction)showImage:(UITapGestureRecognizer *)tap {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZJFDetailPictureViewController *detailPictureViewController = [storyboard instantiateViewControllerWithIdentifier:@"ShowImage"];
    
    //取得触发操作的图片
    UIImageView *tapView = (UIImageView *)tap.view;
    
    ZJFHomeTableViewCell *cell = (ZJFHomeTableViewCell *)[[tapView superview] superview];
    NSLog(@"image at = %lu\n", (unsigned long)[cell.imageStore indexOfObject:tapView.image]);
    
    if (tapView.tag == 1) {
        //确定选择的照片在数组中顺序
        
        detailPictureViewController.imageId = 0;
    } else if (tapView.tag == 2){
        detailPictureViewController.imageId = 1;
    }else if (tapView.tag == 3){
        detailPictureViewController.imageId = 0;
    }else {
        detailPictureViewController.imageId = 0;
    }
    
    NSLog(@"detail.imageID = %d\n",detailPictureViewController.imageId);
    
    detailPictureViewController.imageStore = cell.imageStore;
    
    [self presentViewController:detailPictureViewController animated:YES completion:nil];
}

- (IBAction)refresh:(id)sender {
    [self.tableView reloadData];
}
















@end
