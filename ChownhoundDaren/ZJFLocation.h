//
//  自定义location类

#import <CoreLocation/CoreLocation.h>

@interface ZJFLocation : CLLocation

@property (nonatomic,readonly,strong) NSDate *createDate;

@end
