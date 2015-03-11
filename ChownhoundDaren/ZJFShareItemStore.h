//
//  ZJFShareItemStore.h
//  单实例，用来保存用户分享的全部记录

#import <Foundation/Foundation.h>
@class ZJFLocation;

@interface ZJFShareItemStore : NSObject
{
    NSMutableArray * allItems; //object: ZJFShareItem forkey:time;
}

+ (ZJFShareItemStore *)shareStore;

- (NSArray *) allItems;
- (void) reciveItems:(long)userID withLocation:(ZJFLocation *)location;  //根据用户和所处位置获取服务器数据

@end
