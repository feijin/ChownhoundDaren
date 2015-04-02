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
}

+ (ZJFSNearlyItemStore *)shareStore;
- (NSArray *)allItems;

- (NSString *)itemArchivePath; //获取文件全路径
- (BOOL)saveChanges;
- (void)addItem:(ZJFShareItem *)item;
- (void)findSurroundObjectWithLatitude:(double)latitude Longitude:(double)longitude;


@end
