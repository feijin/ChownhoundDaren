//
//  ZJFCollection.h
//  定义 “收藏”类，

#import <Foundation/Foundation.h>
@class ZJFShareItem;

@interface ZJFCollection : NSObject

@property (nonatomic,readonly,strong) ZJFShareItem *item;  //copy性质收藏，即使原始信息被删除，这里依然保留此记录
@property (nonatomic,readonly,strong) NSDate * createDate; //收藏日期
@property (nonatomic,strong) NSString * tag;   //添加标签


@end
