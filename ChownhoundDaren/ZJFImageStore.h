//
//  ZJFImageStore.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/2.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZJFImageStore : NSObject
{
    NSMutableDictionary *imageStore;
}

+ (ZJFImageStore *)shareStore;

- (void)setImage:(UIImage *)i forKey:(NSString *)s;
- (NSDictionary *)imageForKeys:(NSArray *)array;
- (void)deleteImageForKeys:(NSArray *)array;

@end
