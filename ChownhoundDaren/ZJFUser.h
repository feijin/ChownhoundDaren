//
//  ZJFUser.h
//  用户详细信息

#import <Foundation/Foundation.h>

@interface ZJFUser : NSObject
{
    NSMutableDictionary * allLocationItems; //存放用户历史位置记录 object:locationString forkey:time;
    NSMutableDictionary * allFoodItems; //存放历史分享记录 object:shareItems forkey:time;
}

//邮件或者电话号码具有唯一性
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * name;  //中英文下划线
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * area;
@property (nonatomic, strong) NSString * headPhotoKey;  //圆形头像
@property (nonatomic, strong) NSString * signature;    //签名
@property (nonatomic, strong) NSDate * bornDate;


@end
