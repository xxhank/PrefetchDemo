//
//  SASTableViewController.m
//  Le123PhoneClient
//
//  Created by dhl on 2017/5/27.
//  Copyright © 2017年 Ying Shi Da Quan. All rights reserved.
//

#import "SASTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "NTYTableView.h"

@interface SASTableViewController ()

@end

@implementation SASTableViewController

#pragma mark - life cycle
DQMEMD_TRACE_CHILDREN(self.tableView, self.proxy);

#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = self.tableView?:[self buildTableView];
    self.proxy     = [self buildTableViewProxy];
}

#pragma mark - support subclassing
- (UITableView*)buildTableView {
    return [[[NTYTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] sas_decorate:^(UITableView *tableView) {
        tableView.tableFooterView = [UIView new];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = DQ_F0F0F0;

        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }];
}

- (NTYTableViewProxy*)buildTableViewProxy {
    return [NTYTableViewProxy proxy:self.tableView];
}

#pragma mark - 下拉刷新， 上拉刷新
//
- (void)setRefreshHeader:(BOOL)add refreshBlock:(RefreshingBlock)block {
    [self.tableView.mj_header removeFromSuperview];
    self.tableView.mj_header = nil;

    if (add) {
        MJRefreshHeader *header = [[MJRefreshHeader alloc] init];
        self.tableView.mj_header = header;
        header.refreshingBlock   = ^() {
            if (block) {
                block();
            }
        };
    }
}

- (void)setRefreshFooter:(BOOL)add refreshBlock:(RefreshingBlock)block {
    [self.tableView.mj_footer removeFromSuperview];
    self.tableView.mj_footer = nil;

    if (add) {
        MJRefreshFooter *footer = [[MJRefreshFooter alloc] init];
        self.tableView.mj_footer = footer;
        footer.refreshingBlock   = block;
    }
}

- (void)setRefreshFooterState:(BOOL)hasMoreData {
    self.tableView.mj_footer.state = hasMoreData? MJRefreshStateIdle:MJRefreshStateNoMoreData;
}

- (void)endRefreshFooterState:(BOOL)hasMoreData {
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.state = hasMoreData? MJRefreshStateIdle:MJRefreshStateNoMoreData;
}
- (void)endRefreshHeader {
    [self.tableView.mj_header endRefreshing];
}

@end
