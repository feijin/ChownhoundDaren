//
//  ZJFMyShareTableViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/12.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import "ZJFMyShareTableViewController.h"
#import "ZJFShareItem.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ZJFCurrentUser.h"
#import "ZJFSNearlyItemStore.h"
#import "ZJFMyShareTC.h"
#import "ZJFDetailPictureViewController.h"
#import "MJRefresh.h"
#import "ZJFShowItemNoPictureVC.h"
#import "ZJFShowItemVC.h"

@interface ZJFMyShareTableViewController ()
<UIGestureRecognizerDelegate>
{
    NSArray *imageKeys;  //用于显示照片时传递
    NSString *imageKey;
    
    ZJFShareItem *showItem; //用于segue传递
}

@end

@implementation ZJFMyShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^(){
        [[ZJFSNearlyItemStore shareStore] downloadMyShareItemForRefresh];
        [ZJFSNearlyItemStore shareStore].myShareTableViewController = weakSelf;

    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^(){
        [[ZJFSNearlyItemStore shareStore] downloadMyShareItemAfterRefresh];
        [ZJFSNearlyItemStore shareStore].myShareTableViewController = weakSelf;
    }];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark -tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[ZJFSNearlyItemStore shareStore] myShareItems].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJFMyShareTC *cell = [tableView dequeueReusableCellWithIdentifier:@"MyShareCell"];
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] myShareItems] objectAtIndex:[indexPath row]];
    
    cell.itemDescription.text = item.itemDescription;
    cell.placeName.text = item.placeName;
    
    NSLayoutConstraint *LabelToBottom = [NSLayoutConstraint constraintWithItem:cell
                                                                     attribute:NSLayoutAttributeBottomMargin
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell.itemDescription
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:30];
    [cell addConstraint:LabelToBottom];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] myShareItems] objectAtIndex:[indexPath row]];
    
    CGFloat labelHeight = [self labelHeight:item.itemDescription labelWidth:250];
    
    return labelHeight + 50;
    
}

#pragma mark -tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJFShareItem *item = [[[ZJFSNearlyItemStore shareStore] myShareItems] objectAtIndex:[indexPath row]];
    showItem = item;
    
    NSArray *thumbnails = [[item thumbnailData] allKeys];
    if (thumbnails.count == 0) {
        [self performSegueWithIdentifier:@"ShowItemWithNoPictureFromMyShare"  sender:nil];
    } else {
        [self performSegueWithIdentifier:@"ShowItemWithPictureFromMyShare" sender:nil];
    }
    
    
}

#pragma mark -处理页面跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowItemWithNoPictureFromMyShare"]) {
        ZJFShowItemNoPictureVC *showItemVC = segue.destinationViewController;
        showItemVC.item = showItem;
        showItemVC.sourceVC = @"MyShareVC";
    } else if ([segue.identifier isEqualToString:@"ShowItemWithPictureFromMyShare"]){
        ZJFShowItemVC *showItemVC = segue.destinationViewController;
        showItemVC.item = showItem;
        showItemVC.sourceVC = @"MyShareVC";
    }
}

#pragma mark -计算uilabel高度

- (CGFloat)labelHeight:(NSString *)string labelWidth:(float)width{

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:15.0]
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:allRange];
    
    CGFloat titleHeight;
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    
    titleHeight = ceil(rect.size.height);
    
    return titleHeight + 2;  // 加两个像素,防止emoji被切掉.
}
















@end
