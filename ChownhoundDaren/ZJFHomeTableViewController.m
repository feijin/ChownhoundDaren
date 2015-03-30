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

static const double EARTH_ARC = 6367000;

@interface ZJFHomeTableViewController ()
{
    NSMutableArray *surroundObjects;   //保存获取的数据
    double latitude;
    double longitude;
    int passItem;
}

@end

@implementation ZJFHomeTableViewController

- (void)viewDidLoad {
    //提供三种排序方式，由近到远，由远到近，乱序。。
    [super viewDidLoad];
    
    _locationManager = [[ZJFCurrentLocation shareStore] locationManager];
    
    [_locationManager setDelegate:self];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];

    //在定位完成之前，先给surroundObjects添加一个条目，模拟数据，待定位完成再更新数据，正式应用中，应替换为缓存的数据
    NSString *itemDescription = @"我团的是17:00到22：00的劵，219元一位、去早了五分钟，就在旁边等座的位置休息了五分钟！17:00准时入场。最主要是吃生鱼片之类的！味道差了一点！毕竟放在外面时间长了些，哈根达斯的冰淇淋就四个口味，品种太少了，味道跟专卖店不一样。鲜榨果汁不错！西餐和中餐品种太少了，蟹肉不新鲜！服务员态度和蔼可亲！现场有演出！整个用餐的感觉舒适！愉悦！就是没有吃多少就饱了、19:00多离场的，回到家又饿了！下次还去。";
    
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    [item setValue:itemDescription forKey:@"itemDescription"];
    
    surroundObjects = [[NSMutableArray alloc] init];
    [surroundObjects addObject:item];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation * location = [locations lastObject];
    
   
    
    [ZJFCurrentLocation shareStore].location = location;
    longitude = location.coordinate.longitude;
    latitude = location.coordinate.latitude;
    
    [_locationManager stopUpdatingLocation];
    
    static int hasRefresh = 0;
    if (hasRefresh==0) {
         NSLog(@"access location succeed!\n");
        [self findSurroundObject];
        [self viewWillAppear:YES];
        hasRefresh = 1;
    }
    
}
    
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
        NSLog(@"error: %@\n",[error description]);
}

- (void)findSurroundObject{
    
    [surroundObjects removeAllObjects];
    
    double gridOfLatitude = 0.0105;
    double gridOfLongitude = 0.009;      //代表每个表格的经纬度跨度
    
    double leftLongitude = longitude - gridOfLongitude;
    double rightLongitude = longitude + gridOfLongitude;
    double topLatitude = latitude + gridOfLatitude;
    double buttomLatitude = latitude - gridOfLatitude;
    
    AVQuery *query = [AVQuery queryWithClassName:@"shareItem"];
    [query whereKey:@"latitude" greaterThan:[NSNumber numberWithDouble:buttomLatitude]];
    [query whereKey:@"latitude" lessThan:[NSNumber numberWithDouble:topLatitude]];
    [query whereKey:@"longitude" greaterThan:[NSNumber numberWithDouble:leftLongitude]];
    [query whereKey:@"longitude" lessThan:[NSNumber numberWithDouble:rightLongitude]];
    [query includeKey:@"imageStore"];
    query.limit = 100;
    
    surroundObjects =  [query findObjects];
    
    NSLog(@"find %d objects\n", [surroundObjects count]);
}

- (double)distanceBetween:(double)fromLatitude fromLongitude:(double)fromLongitude toLatitude:(double)toLatitude toLongitude:(double)toLongitude{
    return EARTH_ARC * acos(cos(fromLatitude * M_PI / 180) * cos(toLatitude * M_PI / 180) * cos((toLongitude - fromLongitude) * M_PI / 180) + sin(fromLatitude * M_PI/ 180) * sin(toLatitude *M_PI / 180));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [surroundObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int numberOfMaxCharacters = 50; //如果评论超过50个字，在新页面查看详情
    
    AVObject *item = [surroundObjects objectAtIndex:[indexPath row]];
    NSArray *imageStoreData = [item objectForKey:@"imageStore"];  //得到的数组中包含的是nsdata数据，所以后面需要转换成图片

    //根据是否包含图片，选择相应的cell
    if ([imageStoreData count] != 0) {
        ZJFHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellWithPicture"];
        
        NSMutableArray *imageStore = [[NSMutableArray alloc] init];   //用来保存转换成图片格式后的图片
        
        for (int i=0;i<[imageStoreData count];i++) {
            UIImage *imageItem = [UIImage imageWithData:[[imageStoreData objectAtIndex:i] getData]];
            [imageStore addObject:imageItem];
        }
        
        for (int i=0; i<[imageStore count]; i++) {
            switch (i) {
                case 0:
                    cell.image1.image = [imageStore objectAtIndex:i];
                    break;
                case 1:
                    cell.image2.image = [imageStore objectAtIndex:i];
                    break;
                case 2:
                    cell.image3.image = [imageStore objectAtIndex:i];
                    break;
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
            description = [itemDescription substringToIndex:numberOfMaxCharacters];
            description = [description stringByAppendingString:@"..."];
            cell.moreDescription.hidden = NO;
        }
        
 //       [cell.moreDescription addTarget:self action:@selector(prepareForSegue:sender:) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"description characters = %d\n", length);
        
        [cell.descriptionTextView setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        cell.descriptionTextView.text = description;
        cell.placeName.text = [item objectForKey:@"placeName"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  //设置选中时没有效果
        
        return cell;

        
    } else {
        ZJFHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellNoPicture"];
        
        NSString *description = [item objectForKey:@"itemDescription"];
        int length = description.length;
        
        NSLog(@"description characters = %d\n", length);
        
        [cell.descriptionTextView setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        cell.descriptionTextView.text = description;
        
        return cell;

    }
    
}


- (IBAction)moreDescription:(id)sender {
    ZJFHomeTableViewCell *cell = (ZJFHomeTableViewCell *)[[sender superview] superview]; //获取按钮所在的cell
        
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
   NSLog(@"indexPath row = %d\n",[indexPath row]);
    
    passItem = [indexPath row];
    NSLog(@"description : %@\n",[[surroundObjects objectAtIndex:[indexPath row]] objectForKey:@"itemDescription"]);
    
    ZJFMoreDescriptionViewController *moreDescriptionViewController = [[ZJFMoreDescriptionViewController alloc] init];
    AVObject *item = [surroundObjects objectAtIndex:[indexPath row]];
    
  //  NSLog(@"%@\n",[item objectForKey:@"itemDescription"]);
    
    moreDescriptionViewController.item = item;
    
    NSLog(@"%@\n",item);
    NSLog(@"%@\n",moreDescriptionViewController.item);
    
  //  NSLog(@"%@\n", [moreDescriptionViewController.item objectForKey:@"itemDescription"]);
    
    
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"DetailDescription" source:self destination:moreDescriptionViewController];

    [self prepareForSegue:segue sender:sender];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ZJFMoreDescriptionViewController *moreDescriptionViewController = segue.destinationViewController;
    moreDescriptionViewController.item = [surroundObjects objectAtIndex:passItem];
}

















@end
