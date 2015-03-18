//
//  ZJFImage.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/18.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFImage.h"

@implementation ZJFImage

- (id)initWithImage:(UIImage *)image key:(NSString *)key{
    self = [super init];
    if (self) {
        self.image = image;
        self.imageKey = key;
    }
    
    
    return self;
}

- (id)init{
    NSLog(@"使用 initWithImage: key: 初始化此类\n");
    
    return nil;
}


@end
