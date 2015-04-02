//
//  ZJFImageStore.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/2.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFImageStore.h"

@implementation ZJFImageStore

+ (ZJFImageStore *)shareStore{
    static ZJFImageStore *shareStore = nil;
    
    if (!shareStore) {
        shareStore = [[super alloc] init];
    }
    
    return shareStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    [super allocWithZone:zone];
    return [self shareStore];
}

- (void)deleteImageForKeys:(NSArray *)array{
    if ([array count] == 0) {
        return;
    }
    
    for (NSString *s in array) {
        [imageStore removeObjectForKey:s];
    }
}

- (NSArray *)imageForKeys:(NSArray *)array{
    NSMutableArray *store = [[NSMutableArray alloc] init];
    for (NSString *s in array) {
        [store addObject:[imageStore objectForKey:s]];
    }
    
    return store;
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s{
    [imageStore setObject:i  forKey:s];
}





@end
