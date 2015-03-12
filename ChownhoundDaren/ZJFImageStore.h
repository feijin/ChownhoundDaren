//
//  ZJFImageStore.h
//  管理记录的一组图片
//  ”照片一旦上传应该不存在编辑功能“
#import <Foundation/Foundation.h>

@interface ZJFImageStore : NSObject
{
    NSMutableDictionary * imageKeys;  // object:uiimage forkey:key;
}

- (void)saveToLocal;
- (void)saveToServer;


@end
