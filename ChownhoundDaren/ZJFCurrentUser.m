//
//  ZJFCurrentUser.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/23.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFCurrentUser.h"
#import <AVOSCloud/AVOSCloud.h>



@implementation ZJFCurrentUser

@synthesize weiboUser,username,gender,userDescription,city,nickName,headerImage;

+ (ZJFCurrentUser *)shareCurrentUser{
    static ZJFCurrentUser *currentUser = nil;
    if (!currentUser) {
        currentUser = [[super allocWithZone:nil] init];
    }
    
    return currentUser;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self shareCurrentUser];
}

- (id)init{
    self = [super init];
    
    if (self) {
        if ([AVUser currentUser] != nil) {
            username = [AVUser currentUser].username;
            
            //查询用户信息
            AVQuery *query = [AVQuery queryWithClassName:@"userInformation"];
            [query whereKey:@"username" equalTo:username];
            [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error){
                if (!error) {
                    nickName = [object objectForKey:@"nickName"];
                    gender = [object objectForKey:@"gender"];
                    city = [object objectForKey:@"city"];
                    userDescription = [object objectForKey:@"userDescription"];
                    
                    //处理data字典
                    headerImage = [object objectForKey:@"headerData"];
                }
            }];
            

        }
    }
    
    return self;
}

- (BOOL)isLogin{
    if ([AVUser currentUser]) {
        return YES;
    }else{
        return NO;
    }
}





@end
