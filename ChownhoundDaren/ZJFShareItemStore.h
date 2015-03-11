//
//  ZJFShareItemStore.h
//  管理用户“分享”的类

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
