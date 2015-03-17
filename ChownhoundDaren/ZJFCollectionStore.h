//
//  ZJFCollectionStore.h
//  管理用户 ”收藏“记录的类，单实例。
#import <Foundation/Foundation.h>
@class ZJFCollection;

@interface ZJFCollectionStore : NSObject
{
    NSMutableArray *collections;
}

- (void)addCollection:(ZJFCollection *)collection;
- (ZJFCollection *)deleteCollection:(ZJFCollection *)collection;
- (void)saveToLocal;
- (void)saveToServer;

@end
