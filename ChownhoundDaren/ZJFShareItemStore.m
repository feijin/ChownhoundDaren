//
//  ZJFShareItemStore.m
//  

#import "ZJFShareItemStore.h"
#import "ZJFShareitem.h"
#import "ZJFLocation.h"

@implementation ZJFShareItemStore

- (NSArray *) allItems
{
    return allItems;
}

+ (ZJFShareItemStore *) shareStore
{
    static ZJFShareItemStore * shareStore = nil;
    
    if (!shareStore) {
        shareStore = [[super allocWithZone:nil] init];
    }
    
    return shareStore;
}

+ (id) allocWithZone:(struct _NSZone *)zone
{
    return [self shareStore];
}

- (id) init
{
    self = [super init];
    if (self) {
        allItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
