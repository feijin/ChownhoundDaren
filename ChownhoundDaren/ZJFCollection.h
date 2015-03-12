//
//  ZJFCollection.h
//  定义 “收藏”类，

#import <Foundation/Foundation.h>
@class ZJFShareItem;

@interface ZJFCollection : NSObject
{
    NSMutableArray * tags;
}

@property (nonatomic,readonly,strong) ZJFShareItem *item;  //copy性质收藏，即使原始信息被删除，这里依然保留此记录
@property (nonatomic,readonly,strong) NSDate * createDate; //收藏日期
@property (nonatomic,readonly,strong) NSString *userID;

- (void)addTag:(NSString *)tag;
- (void)deleteTag:(NSString *)tag;


@end
