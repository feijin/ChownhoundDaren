//
//  ZJFUserProfile.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/10.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJFUserProfile : NSObject

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *userDescription;
@property (nonatomic,strong) NSDate *joinDate;
@property (nonatomic,strong) NSData *headerImage;

@end
