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
    self.refreshHeaderEnabled = YES;
    self.refreshFooterEnabled = YES;

    @weakify(self);
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
    [super loadNewData];

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
        [self loadNewDataFinished:[[DataProvider shared] hasMoreData:self.pageIndex]];
    }];
}

- (void)loadMoreData:(BOOL)prefetch {
    if (![[DataProvider shared] hasMoreData:self.pageIndex]) {
        return;
    }
    [super loadMoreData:prefetch];
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
        [self loadMoreDataFinished:[[DataProvider shared] hasMoreData:self.pageIndex]];
    }];
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
    // [self prefetchByCheckOffset:scrollView];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    cell.backgroundColor = indexPath.row % 2? [UIColor whiteColor]:[UIColor grayColor];
    MoviePosterCell *posterCell = [MoviePosterCell cast:cell];
    posterCell.orderLabel.text = STRING(@"%@", @(indexPath.row + 1));
    [self prefetchByCheckIndexPath:indexPath];
};
@end
