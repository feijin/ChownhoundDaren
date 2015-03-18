//
//  ZJFImageStore.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/11.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFImageStore.h"

@implementation ZJFImageStore

+ (ZJFImageStore *)shareStore{
    static ZJFImageStore *imageStore = nil;
    
    if (!imageStore) {
        imageStore = [[super allocWithZone:nil] init];
    }
    
    return imageStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self shareStore];
}

- (id)init{
    self = [super init];
    
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s{
    [dictionary setObject:i forKey:s];
}

- (UIImage *)imageForKey:(NSString *)s{
    return [dictionary objectForKey:s];
}

- (void)deleteImageForKey:(NSString *)s{
    [dictionary removeObjectForKey:s];
}

@end
