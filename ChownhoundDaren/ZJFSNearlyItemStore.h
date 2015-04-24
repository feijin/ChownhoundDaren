//
//  ZJFSNearlyItemStore.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/2.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJFShareItem;
@class ZJFHomeTableViewController;
@class ZJFMyShareTableViewController;
@class ZJFProfileCollectionViewController;
@class ZJFUserProfile;

@interface ZJFSNearlyItemStore : NSObject
{
    NSMutableArray *allItems;
    NSMutableArray *myShareItems;
    NSMutableArray *myCollectionItems;
    NSMutableArray *userShareItems;
}

@property (nonatomic,strong) ZJFHomeTableViewController *homeTableViewController;
@property (nonatomic,strong) ZJFMyShareTableViewController *myShareTableViewController;
@property (nonatomic,strong) ZJFProfileCollectionViewController *profileCollectionViewController;
@property (nonatomic,strong) ZJFUserProfile *userProfile;

+ (ZJFSNearlyItemStore *)shareStore;
- (NSArray *)allItems;
- (NSArray *)myShareItems;
- (NSArray *)myCollectionItems;
- (NSArray *)userShareItems;

- (NSString *)itemArchivePath:(NSString *)s; //获取文件全路径

- (void)getProfile:(NSString *)username;

- (BOOL)saveChanges;
- (void)addItem:(ZJFShareItem *)item for:(NSMutableArray *)array;
- (void)removeItem:(ZJFShareItem *)p from:(NSMutableArray *)array;
- (void)deleteMyShareItems;
- (void)deleteAllItem;

- (void)findSurroundObjectForRefresh;
- (void)findMoreObjectAfterRefresh;

- (void)downloadMyShareItemForRefresh;
- (void)downloadMyShareItemAfterRefresh;

- (void)downloadUserShareItemForRefreshWithUsername:(NSString *)username;
- (void)downloadUserShareItemAfterRefreshWithUsername:(NSString *)username;

- (BOOL)isObject:(NSString *)objectId inStore:(NSArray *)array;

@end
