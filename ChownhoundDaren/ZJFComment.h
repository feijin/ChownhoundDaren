//
//  ZJFComment.h
//  定义 “评论” 类

#import <Foundation/Foundation.h>

@interface ZJFComment : NSObject

@property (nonatomic,readonly) long commentUserID;
@property (nonatomic,readonly,strong) NSString *comment;
@property (nonatomic,readonly,strong) NSDate *commentDate;

@end
