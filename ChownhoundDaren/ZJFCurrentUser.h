//
//  ZJFCurrentUser.h
//  确定当前用户是否登录，或者获得用户id

#import <Foundation/Foundation.h>

@interface ZJFCurrentUser : NSObject

@property (nonatomic) long userID;

- (BOOL) isLogin;

@end
