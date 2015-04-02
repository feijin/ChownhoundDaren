//
//  ZJFSNearlyItemStore.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/2.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFSNearlyItemStore.h"
#import "ZJFShareItem.h"
#import <AVOSCloud/AVOSCloud.h>

static int itemHasDownloads = 0; //用来保存此次程序运行期间，信息的下载量，用于查询时skip参数


@implementation ZJFSNearlyItemStore

#pragma mark -初始化，存档，恢复等
+ (ZJFSNearlyItemStore *)shareStore{
    static ZJFSNearlyItemStore *shareStore = nil;
    
    if (!shareStore) {
        shareStore = [[super alloc] init];
    }
    
    return shareStore;
}

- (id)init{
    self = [super init];
    
    if (self) {
        NSString *path = [self itemArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        NSLog(@"allItems count : %d\n",[allItems count]);
        
        if (!allItems) {
            allItems = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

- (NSArray *)allItems{
    return allItems;
}

- (void)addItem:(ZJFShareItem *)item{
    [allItems addObject:item];
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingString:@"shareItem.archive"];
}

- (BOOL)saveChanges{
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:allItems toFile:path];
}


#pragma mark -从服务器查询附近的信息

- (void)findSurroundObjectWithLatitude:(double)latitude Longitude:(double)longitude{
    //以提供的位置为中心，边长为2km的正方形查询信息并返回
    
     //这两个数据表示表面距离1km时的经度或纬度差值
    double gridOfLatitude = 0.0105;
    double gridOfLongitude = 0.009;
    
    //计算出符合距离要求的经纬度信息
    double leftLongitude = longitude - gridOfLongitude;
    double rightLongitude = longitude + gridOfLongitude;
    double topLatitude = latitude + gridOfLatitude;
    double buttomLatitude = latitude - gridOfLatitude;
    
    AVQuery *query = [AVQuery queryWithClassName:@"shareItem"];
    
    //按发表时间降序排列，首先返回最新的数据信息
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"latitude" greaterThan:[NSNumber numberWithDouble:buttomLatitude]];
    [query whereKey:@"latitude" lessThan:[NSNumber numberWithDouble:topLatitude]];
    [query whereKey:@"longitude" greaterThan:[NSNumber numberWithDouble:leftLongitude]];
    [query whereKey:@"longitude" lessThan:[NSNumber numberWithDouble:rightLongitude]];
    [query includeKey:@"imageStore"];
    query.limit = 30;
}

/*
- (void)findSurroundObject{
    
    [surroundObjects removeAllObjects];
    
 
    

    
 
    
    NSArray *array =  [query findObjects];
    
    for (AVObject *avObject in array) {
        [surroundObjects addObject:avObject];
    }
    
    NSLog(@"find %lu objects\n", (unsigned long)[surroundObjects count]);
}
*/


@end
