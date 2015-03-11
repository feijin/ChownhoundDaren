//
//检测当前用户是否登录


#import "ZJFCurrentUser.h"

@implementation ZJFCurrentUser

@synthesize userID;

- (BOOL) isLogin{
    if (userID > 0 ) {
        return TRUE;
    } else {
        return FALSE;
    }
}

@end
