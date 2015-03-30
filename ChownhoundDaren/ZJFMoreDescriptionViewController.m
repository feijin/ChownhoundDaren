//
//  ZJFMoreDescriptionViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/31.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFMoreDescriptionViewController.h"

@interface ZJFMoreDescriptionViewController ()
{
    
    __weak IBOutlet UITextView *descriptionTextView;
}
@end

@implementation ZJFMoreDescriptionViewController

@synthesize item;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSLog(@"%@\n", item);
    
    descriptionTextView.text = [item objectForKey:@"itemDescription"];
}

@end
