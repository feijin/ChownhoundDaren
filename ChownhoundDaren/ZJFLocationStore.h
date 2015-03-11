//
//  ZJFLocationStore.h
//  管理“一组位置”的类

#import <Foundation/Foundation.h>
@class ZJFLocation;

@interface ZJFLocationStore : NSObject
{
    NSMutableArray *locations;  //存放location记录
}

- (void)addLocation:(ZJFLocation *)location;
- (ZJFLocation *)deleteLocation:(ZJFLocation *)location;
- (BOOL)saveToLocal;
- (BOOL)saveToServer;

@end
