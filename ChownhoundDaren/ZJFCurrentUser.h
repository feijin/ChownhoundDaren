//
//  ZJFCurrentUser.h
//  确定当前用户是否登录，或者获得用户id

#import <Foundation/Foundation.h>

@interface ZJFCurrentUser : NSObject

@property (nonatomic) long userID;

+ (long) getUserID:(NSString *)string;    //根据账户名获取用户id
+ (long) availableUserID;   //从服务器获取可用id，用于注册

- (BOOL) isLogin;


@end
