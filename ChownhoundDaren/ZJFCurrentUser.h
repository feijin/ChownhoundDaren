//
//  ZJFCurrentUser.h
//  确定当前用户是否登录，并指向登录用户，单实例。

#import <Foundation/Foundation.h>
@class ZJFUser;

@interface ZJFCurrentUser : NSObject

@property (nonatomic,strong) ZJFUser * user;

- (BOOL) isLogin;

@end
