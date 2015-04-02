//
//  ZJFShareItem.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/2.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFShareItem.h"

@implementation ZJFShareItem

@synthesize nickName,itemDescription,latitude,longitude,placeName,createDate,userId;

- (id)init{
    self = [super init];
    
    if (self) {
        imageKeys = [[NSMutableArray alloc] init];
        thumbnailData = [[NSMutableArray alloc] init];
        prasice = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)imagekeys{
    return imageKeys;
}

- (NSArray *)thumbnailData{
    return thumbnailData;
}

- (NSArray *)prasice{
    return prasice;
}

- (void)addPrasice:(NSString *)user{
    [prasice addObject:user];
}

- (void)addImage:(UIImage *)image withObjectId:(NSString *)string{
    UIImage *thumbnailImage = [self getThumbnail:image];
    
    NSData *data = UIImageJPEGRepresentation(thumbnailImage, 0.5);
    
    [thumbnailData addObject:data];
    [imageKeys addObject:string];
    
}

- (UIImage *)getThumbnail:(UIImage *)image{
    CGSize newSize = CGSizeMake(71, 71);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:nickName forKey:@"nickName"];
    [aCoder encodeObject:itemDescription forKey:@"itemDescription"];
    [aCoder encodeObject:placeName forKey:@"placeName"];
    [aCoder encodeObject:createDate forKey:@"createDate"];
    [aCoder encodeObject:userId forKey:@"userId"];
    [aCoder encodeDouble:latitude forKey:@"latitude"];
    [aCoder encodeDouble:longitude forKey:@"longitude"];
    [aCoder encodeObject:prasice forKey:@"prasice"];
    [aCoder encodeObject:imageKeys forKey:@"imageKeys"];
    [aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if (self) {
        [self setNickName:[aDecoder decodeObjectForKey:@"nickName"]];
        [self setItemDescription:[aDecoder decodeObjectForKey:@"itemDescription"]];
        [self setPlaceName:[aDecoder decodeObjectForKey:@"placeName"]];
        [self setCreateDate:[aDecoder decodeObjectForKey:@"createDate"]];
        [self setUserId:[aDecoder decodeObjectForKey:@"userId"]];
        [self setLatitude:[aDecoder decodeDoubleForKey:@"latitude"]];
        [self setLongitude:[aDecoder decodeDoubleForKey:@"longitude"]];
        
        prasice = [aDecoder decodeObjectForKey:@"prasice"];
        imageKeys = [aDecoder decodeObjectForKey:@"imageKeys"];
        thumbnailData = [aDecoder decodeObjectForKey:@"thumbnailData"];
    }
    
    return self;
}















@end
