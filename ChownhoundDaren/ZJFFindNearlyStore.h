//
//  ZJFFindNearlyStore.h
//  根据用户和所处位置，寻找合适记录显示在首页中

#import <Foundation/Foundation.h>
@class ZJFShareItem;
@class ZJFLocation;
@class ZJFUser;

@interface ZJFFindNearlyStore : NSObject
{
    NSMutableArray *homeItems;
}

+ (ZJFFindNearlyStore *) shareStore;
- (id)initWithUser:(ZJFUser *)user location:(ZJFLocation *)location; //根据用户名和位置信息获取感兴趣列表，初始化59条数据

- (void)refresh;   //刷新首页列表
- (void)receiveMoreItems:(int)numberOfItemsInStore;    //再获取100条数据

@end
