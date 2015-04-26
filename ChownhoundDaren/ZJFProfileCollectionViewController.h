//
//  ZJFProfileCollectionViewController.h
//  ChownhoundDaren
//
//  Created by 飞 on 15/4/10.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJFProfileCollectionViewController : UICollectionViewController
<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *nickName;

@end
