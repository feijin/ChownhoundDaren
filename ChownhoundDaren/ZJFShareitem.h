//
//  ZJFShareItem.h
//  定义 "分享“ 类

#import <Foundation/Foundation.h>
@class ZJFLocation;
@class ZJFCommentStore;

@interface ZJFShareItem : NSObject
{
    NSMutableArray *praise;  //赞列表，存放用户id
    NSMutableArray *imageStore;
}

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString * description;  //食物评价
@property (nonatomic, strong) NSDate * createDate;
@property (nonatomic, strong) ZJFLocation *location;  //位置信息
//@property (nonatomic,strong) ZJFCommentStore *comments;  //指向一个评论类的对象



- (void)addPraise:(NSString *)userID;
- (void)deletePraise:(NSString *)userID;
- (void)saveToServe;




@end
