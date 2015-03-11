//
//  NSString+Location.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/8.
//  Copyright (c) 2015年 Chowhound Daren. All rights reserved.
//

#import "NSString+Location.h"

@implementation NSString(Location)

+ (NSString *)stringFromLocationX:(NSString *)latitude LocationY:(NSString *)longitude
{
    NSString *locationString = [NSString stringWithFormat:@"%@_%@", latitude, longitude];
    return locationString;;
}

- (NSString *)latitudeString
{
    NSString *latitude = [self componentsSeparatedByString:@"_"][0];
    return latitude;
}

- (NSString *)longitudeString
{
    NSString *longitude = [self componentsSeparatedByString:@"_"][1];
    return longitude;
}


@end
