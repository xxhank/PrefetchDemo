//
//  SASTableViewController.h
//  Le123PhoneClient
//
//  Created by dhl on 2017/5/27.
//  Copyright © 2017年 Ying Shi Da Quan. All rights reserved.
//

#import <UIKit/UIKit.h>
// #import "DQRefresh.h"
#import "SASViewController.h"
#import "NTYTableViewProxy.h"

typedef void (^RefreshingBlock)();

@interface SASTableViewController : SASViewController
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NTYTableViewProxy    *proxy;

//@property (nonatomic, strong) DQRefreshHeader           *header;
//@property (strong, nonatomic) MJRefreshAutoNormalFooter *footer;
// 预加载block
@property (nonatomic, copy) RefreshingBlock preloadBlock;
@property (nonatomic, assign) NSInteger     preloadPosition;

// 设置 header 下拉刷新
- (void)setRefreshHeader:(BOOL)addControl refreshBlock:(RefreshingBlock)block;
// 设置 footer 上拉刷新
- (void)setRefreshFooter:(BOOL)addControl refreshBlock:(RefreshingBlock)block;
/**
 *  设置底部刷新控件的状态
 *
 *  @param hasMoreData 是否还有更多的数据
 */
- (void)setRefreshFooterState:(BOOL)hasMoreData;


- (void)endRefreshFooterState:(BOOL)hasMoreData;
- (void)endRefreshHeader;


// 加载更多

#pragma mark - support subclassing
- (UITableView*)buildTableView;
- (NTYTableViewProxy*)buildTableViewProxy;
@end
