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
#import "ZJFImageStore.h"
#import "ZJFCurrentLocation.h"

static int itemHasDownloads = 0; //用来保存此次程序运行期间，信息的下载量，用于查询时skip参数


@implementation ZJFSNearlyItemStore

#pragma mark -初始化，存档，恢复等
+ (ZJFSNearlyItemStore *)shareStore{
    static ZJFSNearlyItemStore *shareStore = nil;
    
    if (!shareStore) {
        shareStore = [[super allocWithZone:nil] init];
    }
    
    return shareStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self shareStore];
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

- (void)removeItem:(ZJFShareItem *)p{
    NSArray *array = [p imagekeys];
    [[ZJFImageStore shareStore] deleteImageForKeys:array];
    
    [allItems removeObjectIdenticalTo:p];
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

- (void)findSurroundObjectForRefresh{
    //下拉刷新获取最新的数据
    
    //以提供的位置为中心，边长为2km的正方形查询信息并返回
    double latitude = [[ZJFCurrentLocation shareStore] location].coordinate.latitude;
    double longitude = [[ZJFCurrentLocation shareStore] location].coordinate.longitude;
    
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
    
    //用户等待最新的数据时为减少等待时间，开始只读取10条数据
    query.limit = 10;
    //跳过之前已经下载的信息
    query.skip = itemHasDownloads;
    
    NSArray *objects = [query findObjects];
    
    itemHasDownloads += [objects count];
    
    [self handleArrayOfObjects:objects withTag:0];
    
    NSLog(@"刷新完毕\n");
    
}

- (void)findMoreObjectAfterRefresh{
    //沿着已经获取到的数据后面继续读取数据，例如refresh读了10条数据，则此函数读数据时跳过前10条；
    
    double latitude = [[ZJFCurrentLocation shareStore] location].coordinate.latitude;
    double longitude = [[ZJFCurrentLocation shareStore] location].coordinate.longitude;
    
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
    query.skip = itemHasDownloads;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            NSLog(@"后台获取数据成功,获取到： %d条数据\n",[objects count]);
            [self handleArrayOfObjects:objects withTag:itemHasDownloads];
            
            itemHasDownloads += [objects count];
            
        } else{
            NSLog(@"后台获取数据失败：%@\n",error);
        }
    }];

    
}

- (void)handleArrayOfObjects:(NSArray *)objects withTag:(int)itemNumber{
    //处理从服务器返回的每一条数据
    for(int i=0;i<[objects count];i++){
        AVObject *object = [objects objectAtIndex:i];
        
        NSString *itemObjectId = [object objectForKey:@"objectId"];
        
        //如果allitems 没有包含objectId等于它的，则加入此对像
        if (![self isObjectInStore:itemObjectId]) {
            ZJFShareItem *item = [[ZJFShareItem alloc] init];
            item.objectId = [object objectForKey:@"objectId"];
            item.userId = [object objectForKey:@"userId"];
            item.nickName = [object objectForKey:@"nickName"];
            item.placeName = [object objectForKey:@"placeName"];
            item.createDate = [object objectForKey:@"createDate"];
            item.itemDescription = [object objectForKey:@"itemDescription"];
            item.latitude = [[object objectForKey:@"latitude"] doubleValue];
            item.longitude = [[object objectForKey:@"longitude"] doubleValue];
            
            NSArray *imageStore = [object objectForKey:@"imageStore"];
            
            //如果此条信息包含图片
            if ([imageStore count] != 0) {
                for (AVFile *file in imageStore) {
                    NSString *fileObjectId = [file objectId];
                    NSData *fileData = [file getData];
                    
                    UIImage *fileImage = [UIImage imageWithData:fileData];
                    
                    [item addImage:fileImage withObjectId:fileObjectId];
                    [[ZJFImageStore shareStore] setImage:fileImage forKey:fileObjectId];
                }
            }
            
            [allItems insertObject:item atIndex:i + itemNumber];
        }else{
            continue;
        }
        
    }
}

- (void)insertObject:(AVObject *)object withIndex:(int)i{
    
    
    
}

- (BOOL)isObjectInStore:(NSString *)objectId{
    for (ZJFShareItem *item in allItems) {
        NSLog(@"objectId: %@, item id: %@\n", objectId, [item objectId]);
        
        if ([[item objectId] isEqualToString:objectId]) {
            
            return YES;
        }
    }
    
    NSLog(@"not in Store\n");
    return NO;
}



@end
