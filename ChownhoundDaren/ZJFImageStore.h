//
//  ZJFImageStore.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/2.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZJFImageStore : NSObject<NSCoding>
{
    NSMutableDictionary *imageStore;
    NSMutableArray *imageItems;  //存放所有保存到文件系统的图片名，用于清除缓存时删除这些文件
}

+ (ZJFImageStore *)shareStore;

- (void)setImage:(UIImage *)i forKey:(NSString *)s;
- (NSDictionary *)imageForKeys:(NSArray *)array;
- (void)deleteImageForKeys:(NSArray *)array;
- (UIImage *)imageForKey:(NSString *)key;
- (BOOL)saveImageKeys;
- (void)deleteAllImage;

@end
