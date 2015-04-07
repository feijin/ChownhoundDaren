//
//  ZJFSNearlyItemStore.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/2.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJFShareItem;

@interface ZJFSNearlyItemStore : NSObject
{
    NSMutableArray *allItems;
    NSMutableArray *myShareItems;
    NSMutableArray *myCollectionItems;
}

+ (ZJFSNearlyItemStore *)shareStore;
- (NSArray *)allItems;
- (NSArray *)myShareItems;
- (NSArray *)myCollectionItems;

- (NSString *)itemArchivePath:(NSString *)s; //获取文件全路径

- (BOOL)saveChanges;
- (void)addItem:(ZJFShareItem *)item for:(NSMutableArray *)array;
- (void)removeItem:(ZJFShareItem *)p from:(NSMutableArray *)array;

- (void)findSurroundObjectForRefresh;
- (void)findMoreObjectAfterRefresh;

- (void)downloadMyShareItemForRefresh;
- (void)downloadMyShareItemAfterRefresh;

- (BOOL)isObject:(NSString *)objectId inStore:(NSArray *)array;

@end
