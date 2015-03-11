//
//检测当前用户是否登录


#import "ZJFCurrentUser.h"

@implementation ZJFCurrentUser

@synthesize userID;

- (id)init
{
    self = [super init];
    
    if(self)
     userID = 0;
    
    return self;
}

- (BOOL) isLogin{
    if (userID > 0 ) {
        return TRUE;
    } else {
        return FALSE;
    }
}

@end
