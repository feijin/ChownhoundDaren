//
//检测当前用户是否登录


#import "ZJFCurrentUser.h"

@implementation ZJFCurrentUser

@synthesize userID;

+ (ZJFCurrentUser *)shareCurrentUser{
    static ZJFCurrentUser *user = nil;
    
    if (!user) {
        user = [[super allocWithZone:nil] init];
    }
    
    return user;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self shareCurrentUser];
}

@end
