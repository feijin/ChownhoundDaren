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
        shareStore = [[super allocWithZone:nil] init];
    }
    
    return shareStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self allocWithZone:zone];
}

- (void)deleteImageForKeys:(NSArray *)array{
    if ([array count] == 0) {
        return;
    }
    
    for (NSString *s in array) {
        [imageStore removeObjectForKey:s];
        
        NSString *path = [self imagePathForKey:s];
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
}

- (NSDictionary *)imageForKeys:(NSArray *)array{
    NSMutableDictionary *store = [[NSMutableDictionary alloc] init];
    for (NSString *s in array) {
        UIImage *result = [imageStore objectForKey:s];
        if (!result) {
            result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
            
            if (result) {
                [imageStore setObject:result forKey:s];
            } else {
                NSLog(@"Error: unable to find %@",[self imagePathForKey:s]);
            }
        }
        
        [store setObject:result forKey:s];
    }
    
    return store;
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s{
    [imageStore setObject:i  forKey:s];

    NSString *imagePath = [self imagePathForKey:s];
    
    NSData *d = UIImageJPEGRepresentation(i, 0.5);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
        NSLog(@"applicationDocumentsDir exists");
    
    NSError *error;
    
    if (![d writeToFile:imagePath options:NSDataWritingAtomic error:&error]) {
        NSLog(@"witeToFile error: %@\n", error);
    } else{
        NSLog(@"writeToFile succeeded!\n");
    }
}

- (NSString *)imagePathForKey:(NSString *)key{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathExtension:key];
}

- (UIImage *)imageForKey:(NSString *)key{
    UIImage *image = [imageStore objectForKey:key];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[self imagePathForKey:key]];
        
        if (image) {
            [imageStore setObject:image forKey:key];
        } else {
            return nil;
        }
    }
    
    return image;
}

@end
