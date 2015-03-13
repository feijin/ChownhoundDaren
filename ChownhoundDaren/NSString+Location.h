//
//  NSString+Location.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/13.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Location)

+ (NSString *)stringFromLocationX:(NSString *)latitude LocationY:(NSString *)longitude;
- (NSString *)latitudeString;
- (NSString *)longitudeString;

@end
