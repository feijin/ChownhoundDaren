//
//  ZJFImageStore.h
//  管理记录的一组图片
//  ”照片一旦上传应该不存在编辑功能“，单实例。
#import <UIKit/UIKit.h>

@interface ZJFImageStore : NSObject
{
    NSMutableDictionary * dictionary;  // object:uiimage forkey:key;
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s;
- (UIImage *)imageForKey:(NSString *)s;
- (void)deleteImageForKey:(NSString *)s;


@end
