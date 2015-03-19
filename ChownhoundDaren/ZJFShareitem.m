//
//  ZJFShareitem.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/10.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFShareitem.h"
#import "ZJFCurrentUser.h"
#import "ZJFLocation.h"

@implementation ZJFShareItem

@synthesize description,createDate,location;

- (id)init{
    self = [super init];
    
    if (self) {
        self.userID = [ZJFCurrentUser currentUserId];
        praise = [[NSMutableArray alloc] init];
        imageStore = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
