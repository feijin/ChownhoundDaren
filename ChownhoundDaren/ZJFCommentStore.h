//
//  ZJFCommentStore.h
//  管理“一组评论”的类
#import <Foundation/Foundation.h>
@class ZJFComment;

@interface ZJFCommentStore : NSObject
{
    NSMutableArray *comments;  //
}

- (void)addComment:(ZJFComment *)comment;
- (ZJFComment *)deleteComment:(ZJFComment *)comment;
- (BOOL)saveToLocal;
- (BOOL)saveToServer;

@end
