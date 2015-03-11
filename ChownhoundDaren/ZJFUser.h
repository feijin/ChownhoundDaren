//
//  ZJFUser.h
//  用户详细信息

#import <Foundation/Foundation.h>
@class ZJFLocationStore;
@class ZJFShareItemStore;

@interface ZJFUser : NSObject

//邮件或者电话号码具有唯一性
@property (nonatomic, readonly) long userID;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * name;  //中英文下划线
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * area;
@property (nonatomic, strong) NSString * headPhotoKey;  //圆形头像
@property (nonatomic, strong) NSString * signature;    //签名
@property (nonatomic, strong) NSDate * bornDate;
@property (nonatomic, strong) ZJFShareItemStore *shareItemStore; //分享列表
@property (nonatomic, strong) ZJFLocationStore *locationStore; //将位置记录单独存放，已方便日后利用位置信息

@end
