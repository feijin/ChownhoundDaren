//
//  UIView+UIView_GetSuperView.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/17.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "UIView+UIView_GetSuperView.h"

@implementation UIView (UIView_GetSuperView)

- (UITableViewCell *)getCellFromContentviewSubview{
        if ([[[self superview] superview] isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)[[self superview] superview];
        }
        else if ([[[[self superview] superview] superview] isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)[[[self superview] superview] superview];
        }
        else{
            NSLog(@"Something Panic Happens");
        }
        
        return nil;
}

- (UICollectionViewCell *)getCollectionCellFromSubview{
    if ([[[self superview] superview] isKindOfClass:[UICollectionViewCell class]]) {
        return (UICollectionViewCell *)[[self superview] superview];
    } else if ([[[[self superview] superview] superview] isKindOfClass:[UICollectionViewCell class]]){
        return (UICollectionViewCell *)[[[self superview] superview] superview];
    } else{
        NSLog(@"Something Panic Happens from getCollectionCell\n");
    }
    
    return nil;
}

@end
