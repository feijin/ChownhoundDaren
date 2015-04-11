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
#import "ZJFCurrentUser.h"
#import "ZJFHomeTableViewController.h"
#import "ZJFMyShareTableViewController.h"
#import "MJRefresh.h"
#import "ZJFProfileCollectionViewController.h"
#import "ZJFUserProfile.h"

static int nearlyItemHasDownloads = 0; //用来保存此次程序运行期间，信息的下载量，用于查询时skip参数
static int myShareItemHasDownloads = 0;
static int myCollectionItemHasDownloads = 0;
static int userShareItemHasDownloads = 0;


@implementation ZJFSNearlyItemStore

@synthesize homeTableViewController,myShareTableViewController,profileCollectionViewController,userProfile;

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
        NSString *path1 = [self itemArchivePath:@"shareItem.archive"];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path1];
        
        NSString *path2 = [self itemArchivePath:@"myShareItem.archive"];
        myShareItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path2];
        
        NSLog(@"allItems count : %d\n",[allItems count]);
        NSLog(@"myShareItems count: %d\n",[myShareItems count]);
        
        if (!allItems) {
            allItems = [[NSMutableArray alloc] init];
        }
        
        if (!myShareItems) {
            myShareItems = [[NSMutableArray alloc] init];
        }
        
        userShareItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allItems{
    return allItems;
}

- (NSArray *)myShareItems{
    return myShareItems;
}

- (NSArray *)myCollectionItems{
    return myCollectionItems;
}

- (NSArray *)userShareItems{
    return userShareItems;
}

- (void)addItem:(ZJFShareItem *)item for:(NSMutableArray *)array{
    [array addObject:item];
}

- (NSString *)itemArchivePath:(NSString *)s{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingString:s];
}

- (BOOL)saveChanges{
    NSString *path1 = [self itemArchivePath:@"shareItem.archive"];
    NSString *path2 = [self itemArchivePath:@"myShareItem.archive"];
    
    BOOL saveAllitems =  [NSKeyedArchiver archiveRootObject:allItems toFile:path1];
    BOOL saveMyShareItems = [NSKeyedArchiver archiveRootObject:myShareItems toFile:path2];
    
    return saveAllitems && saveMyShareItems;
}

#pragma mark -查询用户信息

- (void)getProfile:(NSString *)username{
    AVQuery *query = [AVUser query];
    
    [query whereKey:@"username" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            NSLog(@"查询用户信息成功！count: %d\n", [objects count]);
            
            AVUser *user = [objects objectAtIndex:0];
            
            ZJFUserProfile *profile = [[ZJFUserProfile alloc] init];
            
            profile.username = user.username;
            profile.nickName = [user objectForKey:@"nickName"];
            profile.userDescription = [user objectForKey:@"userDescription"];
            profile.gender = [user objectForKey:@"gender"];
            profile.city = [user objectForKey:@"city"];
            profile.joinDate = user.createdAt;
            
            userProfile = profile;
        }else{
            NSLog(@"error: %@\n",[error description]);
        }
        
        [self.profileCollectionViewController.collectionView reloadData];
    }];
    
    
}

#pragma mark -从服务器查询附近的信息

- (void)findSurroundObjectForRefresh{
    //下拉刷新获取最新的数据
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    nearlyItemHasDownloads = 0; //每次获取最新数据前，将此数值置零，确保后面跳过数据的值是正确的
    
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
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"latitude" greaterThan:[NSNumber numberWithDouble:buttomLatitude]];
    [query whereKey:@"latitude" lessThan:[NSNumber numberWithDouble:topLatitude]];
    [query whereKey:@"longitude" greaterThan:[NSNumber numberWithDouble:leftLongitude]];
    [query whereKey:@"longitude" lessThan:[NSNumber numberWithDouble:rightLongitude]];
    [query includeKey:@"imageStore"];
    
    //一次读取10条数据
    query.limit = 10;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            NSLog(@"findObjects count: %d\n",[objects count]);
            
            //如果取得新数据成功,清空之前下载的数据
            if([objects count] != 0){
                [allItems removeAllObjects];
            }
            
            NSLog(@"\n allItems object count: %d\n",[allItems count]);
            
            nearlyItemHasDownloads += [objects count];
            
            [self handleArrayOfObjects:objects withTag:0 withArray:allItems];
           
            [self.homeTableViewController.tableView reloadData];
            [self.homeTableViewController.tableView.header endRefreshing];
           
            NSLog(@"刷新完毕\n");
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        }

    }];
    
}

- (void)findMoreObjectAfterRefresh{
    //沿着已经获取到的数据后面继续读取数据，例如refresh读了10条数据，则此函数读数据时跳过前10条；
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
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
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"latitude" greaterThan:[NSNumber numberWithDouble:buttomLatitude]];
    [query whereKey:@"latitude" lessThan:[NSNumber numberWithDouble:topLatitude]];
    [query whereKey:@"longitude" greaterThan:[NSNumber numberWithDouble:leftLongitude]];
    [query whereKey:@"longitude" lessThan:[NSNumber numberWithDouble:rightLongitude]];
    [query includeKey:@"imageStore"];
    
    query.limit = 10;
    
    //应用运行后第一次获取更多数据，需要跳过当前数组中已经保存的信息数，如果非零，前面已经刷新过，直接采用它的值
    if (nearlyItemHasDownloads == 0) {
        nearlyItemHasDownloads += [[[ZJFSNearlyItemStore shareStore] allItems] count];
    }
    query.skip = nearlyItemHasDownloads;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"后台获取数据成功,获取到： %d条数据\n",[objects count]);
        
        [self handleArrayOfObjects:objects withTag:nearlyItemHasDownloads withArray:allItems];
        
        nearlyItemHasDownloads += [objects count];
        
        [self.homeTableViewController.tableView reloadData];
        [self.homeTableViewController.tableView.footer endRefreshing];
        
        NSLog(@"获取更多数据成功！\n");
    }];
    
    
}

#pragma mark -下载我的分享
- (void)downloadMyShareItemForRefresh{
    //用于下拉刷新，获取最新数据
    myShareItemHasDownloads = 0;  //将已经下载的数据数归零
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AVQuery *query = [AVQuery queryWithClassName:@"shareItem"];
    [query whereKey:@"username" equalTo:[ZJFCurrentUser shareCurrentUser].username];
    [query orderByDescending:@"updatedAt"];
    [query includeKey:@"imageStore"];
    
    query.limit = 10;
    
    //[query includeKey:@"imageStore"];
    
    [query findObjectsInBackgroundWithTarget:self selector:@selector(handleFindNearlyItems:error:)];
    
}

- (void)downloadMyShareItemAfterRefresh{
    //用户上滑刷新，获取后面接着的数据
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AVQuery *query = [AVQuery queryWithClassName:@"shareItem"];
    [query whereKey:@"username" equalTo:[ZJFCurrentUser shareCurrentUser].username];
    [query orderByDescending:@"updatedAt"];
    [query includeKey:@"imageStore"];
    
    query.limit = 10;
    
    if (myShareItemHasDownloads == 0) {
        myShareItemHasDownloads += [[[ZJFSNearlyItemStore shareStore] myShareItems] count];
    }
    query.skip = myShareItemHasDownloads;
    
    //直接下拉获取更多数据
    //[query includeKey:@"imageStore"];
   
    [query findObjectsInBackgroundWithTarget:self selector:@selector(handleArrayOfObjects:withTag:withArray:)];
    
    
}

- (void)downloadUserShareItemForRefreshWithUsername:(NSString *)username{
    //用于下拉刷新，获取最新数据
    userShareItemHasDownloads = 0;  //将已经下载的数据数归零
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AVQuery *query = [AVQuery queryWithClassName:@"shareItem"];
    [query whereKey:@"username" equalTo:[ZJFCurrentUser shareCurrentUser].username];
    [query orderByDescending:@"updatedAt"];
    [query includeKey:@"imageStore"];
    
    query.limit = 10;
    
    //[query includeKey:@"imageStore"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([objects count] != 0) {
            [userShareItems removeAllObjects];
        }
        
        [self handleArrayOfObjects:objects withTag:userShareItemHasDownloads withArray:userShareItems];
        userShareItemHasDownloads += [objects count];
        
        [self.profileCollectionViewController.collectionView reloadData];
        
        NSLog(@"他的分享刷新完成！\n");
    }];
}

- (void)downloadUserShareItemAfterRefreshWithUsername:(NSString *)username{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AVQuery *query = [AVQuery queryWithClassName:@"shareItem"];
    [query whereKey:@"username" equalTo:username];
    [query orderByDescending:@"updatedAt"];
    [query includeKey:@"imageStore"];
    
    query.limit = 10;
    
    if (userShareItemHasDownloads == 0) {
        userShareItemHasDownloads += [[[ZJFSNearlyItemStore shareStore] userShareItems] count];
    }
    query.skip = userShareItemHasDownloads;
    
    //直接下拉获取更多数据
    //[query includeKey:@"imageStore"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        [self handleArrayOfObjects:objects withTag:userShareItemHasDownloads withArray:userShareItems];
        userShareItemHasDownloads += [objects count];
        
        [self.profileCollectionViewController.collectionView reloadData];
        [self.profileCollectionViewController.collectionView.footer endRefreshing];
        
        NSLog(@"他的分享刷新完成！\n");
    }];
}

#pragma mark -处理下载下来的数据
- (void)handleArrayOfObjects:(NSArray *)objects withTag:(int)itemNumber withArray:(NSMutableArray *)array{
    //处理从服务器返回的每一条数据
    for(int i=0;i<[objects count];i++){
        AVObject *object = [objects objectAtIndex:i];
        
        NSString *itemObjectId = [object objectForKey:@"objectId"];
        NSLog(@"\nobjectId: %@\n", itemObjectId);
        
        //如果array 没有包含objectId等于它的，则加入此对像
        if (![self isObject:itemObjectId inStore:array]) {
            ZJFShareItem *item = [[ZJFShareItem alloc] init];
            
            item.objectId = [object objectForKey:@"objectId"];
            item.username = [object objectForKey:@"username"];
            
            //根据item的username查询用户信息，并存储到item中
            AVQuery *query = [AVQuery queryWithClassName:@"userInformation"];
            [query whereKey:@"username" equalTo:item.username];
            
            AVObject *userInformation = [query getFirstObject];
            
            item.nickName = [userInformation objectForKey:@"nickName"];
            item.headerImage = [userInformation objectForKey:@"headerData"];
            
            NSLog(@"item.nickname: %@\n",item.nickName);
            
            item.placeName = [object objectForKey:@"placeName"];
            item.createDate = object.updatedAt;
            item.itemDescription = [object objectForKey:@"itemDescription"];
            item.latitude = [[object objectForKey:@"latitude"] doubleValue];
            item.longitude = [[object objectForKey:@"longitude"] doubleValue];
            
            NSArray *arrayKey = [object objectForKey:@"imageStore"];
            for (AVFile *file in arrayKey) {
                [item addFileName:file.name forFileId:file.objectId];
            }
            
            NSDictionary *dictionary = [object objectForKey:@"thumbnailData"];
            
            //处理thumbnailData,因为它保存的格式为base64 string，所以需要转换为data格式
            
            NSArray *keys = [dictionary allKeys];
            
            for (NSString *s in keys) {
                
                NSDictionary *dic = [dictionary objectForKey:s];
                
                NSString *string = [dic objectForKey:@"base64"];    //得到的是nsstring格式数据
                
                NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];     //这才是nsdata数据格式
                
                [item setThumbnailData:data forKey:s];
            }
            
            [array addObject:item];
        }else{
            continue;
        }
        
    }

}

- (void)handleFindNearlyItems:(NSArray *)objects error:(NSError *)error{
    
    
}


- (BOOL)isObject:(NSString *)objectId inStore:(NSArray *)array{
    for (ZJFShareItem *item in array) {
        if ([[item objectId] isEqualToString:objectId]) {
            return YES;
        }
    }
    return NO;
}



@end
