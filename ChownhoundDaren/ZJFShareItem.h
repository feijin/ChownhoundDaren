//
//  ZJFShareItem.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/2.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZJFShareItem : NSObject<NSCoding>
{
    NSMutableDictionary *imageStore;
    NSMutableDictionary *thumbnailData;
    NSMutableArray *prasice;
}

@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *createDate;;
@property (nonatomic,strong) NSString *placeName;
@property (nonatomic,strong) NSString *itemDescription;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

- (NSDictionary *)thumbnailData;
- (NSArray *)prasice;
- (NSDictionary *)imageStore;

- (void)addFileId:(NSString *)fileId forFileName:(NSString *)fileName;
- (void)addPrasice:(NSString *)userId;
- (void)setThumbnailData:(NSData *)data forKey:(NSString *)key;

@end
