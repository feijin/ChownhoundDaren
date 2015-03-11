//
//  NSString+Location.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/8.
//  Copyright (c) 2015年 Chowhound Daren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Location)

+ (NSString *)stringFromLocationX:(NSString *)latitude LocationY:(NSString *)longitude;

- (NSString *)latitudeString;
- (NSString *)longitudeString;

@end
