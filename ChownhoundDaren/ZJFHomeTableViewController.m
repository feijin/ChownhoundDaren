//
//  ZJFHomeTableViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFHomeTableViewController.h"
#import "ZJFCurrentLocation.h"

@interface ZJFHomeTableViewController ()

@end

@implementation ZJFHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationManager = [[ZJFCurrentLocation shareStore] locationManager];
    
    [_locationManager setDelegate:self];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
    
}
    
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation * location = [locations lastObject]; 
    
    [ZJFCurrentLocation shareStore].location = location;

//    [_locationManager stopUpdatingLocation];
}
    
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
        NSLog(@"error: %@\n",[error description]);
}

@end
