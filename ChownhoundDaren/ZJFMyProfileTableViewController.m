//
//  ZJFMyProfileTableViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/24.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFMyProfileTableViewController.h"
#import "ZJFMyProfileTableViewCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ZJFCurrentUser.h"

@interface ZJFMyProfileTableViewController()


@end

@implementation ZJFMyProfileTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    [[self tableView] reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[self tableView] reloadData];
    
//    NSLog(@"%@\n",[[ZJFCurrentUser shareCurrentUser] getNickname]);
}


#pragma mark -tableview信息
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 2;
    } else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section]==0) {
        ZJFMyProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileFirstCell"];
        NSLog(@"nickname: %@\n",[[ZJFCurrentUser shareCurrentUser] nickName]);
        cell.nickNameLabel.text = [[ZJFCurrentUser shareCurrentUser] nickName];
        
        NSString *gender = [[ZJFCurrentUser shareCurrentUser] gender];
        UIImage *image = [UIImage imageNamed:gender];
        cell.imageViewOfGender.image = image;
        
        if ([[ZJFCurrentUser shareCurrentUser] userDescription]) {
            cell.signature.text = [[ZJFCurrentUser shareCurrentUser] userDescription];
        } else{
            cell.signature.text = @"为自己说点什么...";
        }
        
        return cell;
    } else if([indexPath section]==1) {
        ZJFMyProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileSecondCell"];
        if ([indexPath row]==0) {
            cell.labelOfShares.text = @"我的分享";
            cell.imageViewOfShares.image = [UIImage imageNamed:@"fenxiang1"];
            return cell;
        } else{
            cell.labelOfShares.text = @"我的互动";
            cell.imageViewOfShares.image = [UIImage imageNamed:@"zanyang1"];
            return cell;
        }
    }else{
        ZJFMyProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileSecondCell"];
        cell.labelOfShares.text = @"设置";
        cell.imageViewOfShares.image = [UIImage imageNamed:@"shezhi1"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section]==0) {
        return 100.f;
    }else{
        return 62.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section] == 0) {
        [self performSegueWithIdentifier:@"ShowProfile" sender:indexPath];
    } }




@end
