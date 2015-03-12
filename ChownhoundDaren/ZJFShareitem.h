//
//  ZJFShareItem.h
//  定义 "分享“ 类

#import <Foundation/Foundation.h>
@class ZJFLocation;
@class ZJFCommentStore;
@class ZJFImageStore;
@class ZJFUser;

@interface ZJFShareItem : NSObject
{
    NSMutableArray *praise;  //赞列表，存放用户id
   // NSString * userID;  //邮件或者手机号
}

@property (nonatomic, strong) NSString * description;  //食物评价
@property (nonatomic, strong) NSDate * createDate;
@property (nonatomic, strong) ZJFLocation *location;  //位置信息
@property (nonatomic,strong) ZJFCommentStore *comments;  //指向一个评论类的对象
@property (nonatomic,strong) ZJFImageStore *images;  //存储跟随此记录上传的图片


//可选，是为了尽量简化用户上传信息的复杂性，为app瘦身。
//@property (nonatomic, strong) NSString * restaurantName;
//@property (nonatomic, strong) NSString * priciseAddress;   //位置定位的补充，某某街多少号
//@property (nonatomic) double price;
//@property (nonatomic, strong) NSString * name;



- (void)addPraise:(ZJFUser *)user;
- (void)deletePraise:(ZJFUser *)user;




@end
