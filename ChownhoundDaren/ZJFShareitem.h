//
//  ZJFShareItem.h
//  定义分享的详细信息

#import <Foundation/Foundation.h>
@class ZJFLocation;

@interface ZJFShareItem : NSObject
{
    NSMutableArray * imageKeys;  //一组照片的键
}

@property (nonatomic, readonly) long userID;  //上传者
@property (nonatomic, strong) NSString * description;  //食物评价
@property (nonatomic, strong) NSString * restaurantName;
@property (nonatomic, strong) NSString * priciseAddress;   //位置定位的补充，某某街多少号
@property (nonatomic, strong) NSDate * createDate;
@property (nonatomic, strong) ZJFLocation *location;  //位置信息
@property (nonatomic) double price;



@end
