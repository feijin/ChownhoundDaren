//
//  ZJFShareItem.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/2.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFShareItem.h"
#import "ZJFImageStore.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation ZJFShareItem

@synthesize nickName,itemDescription,latitude,longitude,placeName,createDate,userId,objectId;

- (id)init{
    self = [super init];
    
    if (self) {
        imageStore = [[NSMutableDictionary alloc] init];
        thumbnailData = [[NSMutableDictionary alloc] init];
        prasice = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)prasice{
    return prasice;
}

- (void)addPrasice:(NSString *)user{
    [prasice addObject:user];
    
}

- (NSDictionary *)imageStore{
    return imageStore;
}

- (void)addFileId:(NSString *)fileId forFileName:(NSString *)fileName{
    [imageStore setObject:fileName forKey:fileId];
}

- (NSDictionary *)thumbnailData{
    return thumbnailData;
}

- (void)setThumbnailData:(NSData *)data forKey:(NSString *)key{
    
    [thumbnailData setObject:data forKey:key];
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:objectId forKey:@"objectId"];
    [aCoder encodeObject:nickName forKey:@"nickName"];
    [aCoder encodeObject:itemDescription forKey:@"itemDescription"];
    [aCoder encodeObject:placeName forKey:@"placeName"];
    [aCoder encodeObject:createDate forKey:@"createDate"];
    [aCoder encodeObject:userId forKey:@"userId"];
    [aCoder encodeDouble:latitude forKey:@"latitude"];
    [aCoder encodeDouble:longitude forKey:@"longitude"];
    [aCoder encodeObject:prasice forKey:@"prasice"];
    [aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
    [aCoder encodeObject:imageStore forKey:@"imageStore"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if (self) {
        [self setObjectId:[aDecoder decodeObjectForKey:@"objectId"]];
        [self setNickName:[aDecoder decodeObjectForKey:@"nickName"]];
        [self setItemDescription:[aDecoder decodeObjectForKey:@"itemDescription"]];
        [self setPlaceName:[aDecoder decodeObjectForKey:@"placeName"]];
        [self setCreateDate:[aDecoder decodeObjectForKey:@"createDate"]];
        [self setUserId:[aDecoder decodeObjectForKey:@"userId"]];
        [self setLatitude:[aDecoder decodeDoubleForKey:@"latitude"]];
        [self setLongitude:[aDecoder decodeDoubleForKey:@"longitude"]];
        
        prasice = [aDecoder decodeObjectForKey:@"prasice"];
        thumbnailData = [aDecoder decodeObjectForKey:@"thumbnailData"];
        imageStore = [aDecoder decodeObjectForKey:@"imageStore"];
    }
    
    return self;
}















@end
