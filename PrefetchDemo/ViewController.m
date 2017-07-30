//
//  ViewController.m
//  PrefetchDemo
//
//  Created by wangchao9 on 2017/7/29.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

#import "MoviePosterCell.h"
#import "DataProvider.h"
#import "NTYTableViewProxy.h"


@interface ViewController ()
#if USE_NATIVE
<UITableViewDataSource, UITableViewDelegate>
#endif // if USE_NATIVE
// @property (nonatomic, weak) IBOutlet UITableView                           *tableView;
@property (nonatomic, strong) NSMutableArray<MoviePosterCellViewModelType> *movies;
@property (nonatomic, assign) NSUInteger                                    pageIndex;
@property (nonatomic, assign) BOOL                                          prefetching;
// @property (nonatomic, strong) NTYTableViewProxy                            *proxy;
@end

@implementation ViewController
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    [self loadNewData];
}

- (void)buildUI {
   #if USE_NATIVE
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
   #endif // if USE_NATIVE
    // Set header
    @weakify(self);
    self.tableView.mj_header = [[MJRefreshGifHeader headerWithRefreshingBlock:^{
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

    self.tableView.mj_footer = [[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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

    self.proxy                 = [NTYTableViewProxy proxy:self.tableView];
    self.proxy.willDisplayCell = ^(__kindof NTYTableViewProxy*_Nonnull proxy, UITableView*_Nonnull tableView, UITableViewCell*_Nonnull cell, NSIndexPath*_Nonnull indexPath) {
        @strongify(self);
        [self tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    };
    self.proxy.didScroll = ^(NTYScrollViewProxy*_Nonnull proxy, UIScrollView*_Nonnull scrollView) {
        @strongify(self);
        [self scrollViewDidScroll:scrollView];
    };
}
#pragma mark -
- (void)loadNewData {
    [self cancelPrefetch];
    self.pageIndex = 0;
    @weakify(self);
    [[DataProvider shared] loadData:self.pageIndex completion:^(MoviePosterCellViewModelArray *urls) {
        @strongify(self);
   #if USE_NATIVE
        self.movies = urls.mutableCopy;
        [self.tableView reloadData];
   #else // if 0
        [self.proxy updateViewModels:urls];
   #endif // if 0
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.state = [[DataProvider shared] hasMoreData:self.pageIndex]? MJRefreshStateIdle:MJRefreshStateNoMoreData;
    }];
}

- (void)loadMoreData:(BOOL)prefetch {
    if (![[DataProvider shared] hasMoreData:self.pageIndex]) {
        return;
    }

    if (prefetch) {
        self.tableView.mj_footer.state = MJRefreshStateRefreshing;
    }

    @weakify(self);
    [[DataProvider shared] loadData:self.pageIndex + 1 completion:^(MoviePosterCellViewModelArray *urls) {
        @strongify(self);
        self.pageIndex += 1;
   #if USE_NATIVE
        [self.tableView beginUpdates];
        NSMutableArray*indexPaths = [NSMutableArray arrayWithCapacity:urls.count];
        NSUInteger row = self.movies.count;
        [self.movies addObjectsFromArray:urls];
        for (NSString *url in urls) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
            row++;
        }
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationAutomatic)];
        [self.tableView endUpdates];
   #else // if 0
        [self.proxy appendViewModels:urls];
   #endif // if 0
        self.prefetching = NO;
        //[self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.state = [[DataProvider shared] hasMoreData:self.pageIndex]? MJRefreshStateIdle:MJRefreshStateNoMoreData;
    }];
}
- (void)cancelPrefetch {
    self.prefetching = NO;
    NSLogInfo(@"cancel prefetch");
}
#pragma mark - UITableViewDataSource
#if USE_NATIVE
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"MoviePosterCell" configuration:^(id cell) {
    }];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    MoviePosterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoviePosterCell"];
    [cell setViewModel:self.movies[indexPath.row]];
    return cell;
}
#endif // if USE_NATIVE
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    if (self.prefetching) {
        return;
    }

    CGFloat contentOffset   = RECT_BOTTOM(scrollView.bounds);
    CGFloat contentHeight   = scrollView.contentSize.height;
    CGFloat pageHeight      = RECT_HEGIHT(scrollView.frame);
    CGFloat contentDistance = contentHeight - contentOffset;
    CGFloat contentVisited  = contentOffset / contentHeight;
    if (contentDistance < pageHeight * 0.3 && contentDistance > 10 /*contentVisited >= 0.8 && contentVisited < 0.95*/) {
        NSLogInfo(@"%@", @[@(contentOffset), @(contentHeight), @(contentVisited), @(contentHeight * (1 - contentVisited))]);
        self.prefetching = YES;
        NSLog(@"start prefetch");
        [self loadMoreData:YES];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    cell.backgroundColor = indexPath.row % 2? [UIColor whiteColor]:[UIColor grayColor];
};
@end
