//
//  ZJFShareItemStore.h
//  管理用户“分享”的类，单实例，本地和服务器上保存所有shareItem，根据id等筛选出相应数组，来实现不同用户的需求。

#import <Foundation/Foundation.h>
@class ZJFLocation;
@class ZJFShareItem;

@interface ZJFShareItemStore : NSObject
{
    NSMutableArray * allItems; 
}

+ (ZJFShareItemStore *)shareStore;

- (NSArray *) allItems;    //获取用户的最近记录，默认：20条
- (ZJFShareItem *) deleteItem;    //删除用户删除的记录
- (void)addItem:(ZJFShareItem *)item;   //添加用户分享记录

- (void)receiveMoreItems;   //从服务器获取更多“分享”记录


@end
