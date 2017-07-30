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
@property (nonatomic, assign) BOOL             prefetching;
@property (nonatomic, strong) MJRefreshHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshFooter *refreshFooter;
@end

@implementation SASTableViewController

#pragma mark - life cycle
DQMEMD_TRACE_CHILDREN(self.tableView, self.proxy);

#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.prefetchOffsetPrecent = 0.3;
    self.prefetchRowDistance   = 2;

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

#pragma mark - header/footer
- (BOOL)refreshHeaderEnabled {return self.tableView.mj_header != nil;}
- (void)setRefreshHeaderEnabled:(BOOL)refreshHeaderEnabled {
    if (refreshHeaderEnabled) {
        [self addRefreshHeader];
    } else {
        [self removeRefreshHeader];
    }
}

- (BOOL)refreshFooterEnabled {return self.tableView.mj_footer != nil;}
- (void)setRefreshFooterEnabled:(BOOL)refreshFooterEnabled {
    if (refreshFooterEnabled) {
        [self addRefreshFooter];
    } else {
        [self removeRefreshFooter];
    }
}

#pragma mark - header/footer  private
- (void)addRefreshHeader {
    if (!self.refreshHeader) {
        @weakify(self);
        self.refreshHeader = [[MJRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self loadNewData];
        }] sas_decorate:^(__kindof MJRefreshGifHeader*_Nonnull header) {
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;

            const NSUInteger idleImagesCount = 13;
            NSMutableArray *idleImages = [NSMutableArray arrayWithCapacity:idleImagesCount];
            for (int i = 1; i <= idleImagesCount; i++) {
                [idleImages addObject:[UIImage imageNamed:STRING(@"下拉%d", i)]];
            }
            [header setImages:idleImages forState:MJRefreshStateIdle];

            const NSUInteger refreshingImagesCount = 19;
            NSMutableArray *refreshingImages = [NSMutableArray arrayWithCapacity:refreshingImagesCount];
            for (int i = 1; i <= refreshingImagesCount; i++) {
                [refreshingImages addObject:[UIImage imageNamed:STRING(@"转动%d", i)]];
            }
            [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
        }];
    }

    self.tableView.mj_header = self.refreshHeader;
}

- (void)removeRefreshHeader {
    [self.tableView.mj_header removeFromSuperview];
    self.tableView.mj_header = nil;
}

- (void)addRefreshFooter {
    if (!self.refreshFooter) {
        @weakify(self);
        self.refreshFooter = [[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            if (!self.prefetching) {
                [self loadMoreData:NO];
            }
        }] sas_decorate:^(__kindof MJRefreshBackNormalFooter*_Nonnull footer) {
            footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            footer.stateLabel.textColor = COLOR_HEXA(0x000000, 0.5);
            footer.stateLabel.font = [UIFont systemFontOfSize:14];

            // 初始化文字
            [footer setTitle:@"上拉加载更多 ..." forState:MJRefreshStateIdle];
            [footer setTitle:@"松开手指刷新 ..." forState:MJRefreshStatePulling];
            [footer setTitle:@"正在加载 ..." forState:MJRefreshStateRefreshing];
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
        }];
    }

    self.tableView.mj_footer = self.refreshFooter;
}

- (void)removeRefreshFooter {
    [self.tableView.mj_footer removeFromSuperview];
    self.tableView.mj_footer = nil;
}

#pragma mark - header/footer subclassing
- (void)loadNewData {
    NSLogInfo(@"");
    [self cancelPrefetch];
}

- (void)loadMoreData:(BOOL)prefetch {
    NSLogInfo(@"prefetch: %@", @(prefetch));
    if (prefetch) {
        self.tableView.mj_footer.state = MJRefreshStateRefreshing;
    }
}

- (void)loadNewDataFinished:(BOOL)hasMoreData {
    [self.tableView.mj_header endRefreshing];
    self.tableView.mj_footer.state = hasMoreData? MJRefreshStateIdle:MJRefreshStateNoMoreData;
}

- (void)loadMoreDataFinished:(BOOL)hasMoreData {
    self.prefetching               = NO;
    self.tableView.mj_footer.state = hasMoreData? MJRefreshStateIdle:MJRefreshStateNoMoreData;
}

#pragma mark - prefetch
- (void)prefetchByCheckOffset:(UIScrollView*)scrollView  {
    if (self.prefetching) {
        return;
    }

    CGFloat contentOffset   = RECT_BOTTOM(scrollView.bounds);
    CGFloat contentHeight   = scrollView.contentSize.height;
    CGFloat pageHeight      = RECT_HEGIHT(scrollView.frame);
    CGFloat contentDistance = contentHeight - contentOffset;

    BOOL    canPrefetch = contentDistance < pageHeight * self.prefetchOffsetPrecent;
    BOOL    notOverflow = contentDistance > 10; /// 避免向上拉动tableView引起的越界
    if (notOverflow && canPrefetch) {
        NSLogInfo(@"%@", @[@(contentOffset), @(contentHeight)]);
        NSLog(@"start prefetch");
        self.prefetching = YES;
        [self loadMoreData:YES];
    }
}

- (void)prefetchByCheckIndexPath:(NSIndexPath*)indexPath {
    if (self.prefetching) {
        return;
    }

    NSUInteger totalRows           = 0;
    NSUInteger totalRowForCurrent  = 0;
    NSUInteger currentSectionIndex = indexPath.section;
    NSUInteger sectionCount        = self.tableView.numberOfSections;
    for (NSUInteger index = 0; index < sectionCount; index++) {
        NSUInteger rowCount = [self.tableView numberOfRowsInSection:index];
        totalRows += rowCount;
        if (index < currentSectionIndex) {
            totalRowForCurrent += rowCount;
        }
    }

    totalRowForCurrent += indexPath.row + 1;
    NSInteger rowDistance = totalRows - totalRowForCurrent;

    NSLogInfo(@"%@", @[@(totalRowForCurrent), @(totalRows)]);
    BOOL canPrefetch = rowDistance < self.prefetchRowDistance + 1;
    BOOL notOverflow = rowDistance >= 0;      /// 避免向上拉动tableView引起的越界
    if (notOverflow && canPrefetch) {
        NSLog(@"start prefetch");
        self.prefetching = YES;
        [self loadMoreData:YES];
    }
}

- (void)cancelPrefetch {
    self.prefetching = NO;
    NSLogInfo(@"cancel prefetch");
}

@end
