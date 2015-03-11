//
//  ZJFUser.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/10.
//  Copyright (c) 2015年 Chowhound Daren. All rights reserved.
//

#import "ZJFUser.h"

@implementation ZJFUser

@synthesize userID,email,name,phoneNumber,area,bornDate,signature,headPhotoKey;

- (id)initWithUserID:(long)id
{
    self = [super init];
    
    if (self) {
        userID = id;
    }
    
    return self;
}

- (id)init
{
    NSAssert(false,@"this class is Singleton !");
    return nil;
}

@end
