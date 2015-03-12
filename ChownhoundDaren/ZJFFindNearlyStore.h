//
//  ZJFFindNearlyStore.h
//  根据用户和所处位置，寻找合适记录显示在首页中，不是单实例

#import <Foundation/Foundation.h>
@class ZJFShareItem;
@class ZJFLocation;
@class ZJFUser;

@interface ZJFFindNearlyStore : NSObject
{
    NSMutableArray *homeItems;
}

- (id)initWithUser:(ZJFUser *)user location:(ZJFLocation *)location; //根据用户名和位置信息获取感兴趣列表，初始化50条数据

- (void)refresh;   //下拉获取新信息，刷新首页列表
- (void)receiveMoreItems:(int)numberOfItemsInStore;    //上拉，获取更多数据

- (void)saveToLocal;
- (void)saveToServer;

@end
