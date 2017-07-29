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
#import <SDWebImage/UIImageView+WebCache.h>
#import <libextobjc/EXTScope.h>
#import "NSObject+Decorate.h"
#import "NTY_Macros.h"
#import "Logger.h"
#import "MoviePosterCell.h"
#import "DataProvider.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView        *tableView;
@property (nonatomic, strong) NSMutableArray<NSString*> *movies;
@property (nonatomic, assign) NSUInteger                 pageIndex;
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
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
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
        [self loadMoreData:NO];
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
#pragma mark -
- (void)loadNewData {
    self.pageIndex = 0;
    @weakify(self);
    [[DataProvider shared] loadData:self.pageIndex completion:^(NSArray<NSString*> *urls) {
        @strongify(self);
        self.movies = urls.mutableCopy;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.state = [[DataProvider shared] hasMoreData:self.pageIndex]? MJRefreshStateIdle:MJRefreshStateNoMoreData;
    }];
}

- (void)loadMoreData:(BOOL)prefetch {
    @weakify(self);
    [[DataProvider shared] loadData:self.pageIndex + 1 completion:^(NSArray<NSString*> *urls) {
        @strongify(self);
        self.pageIndex += 1;

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

        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.state = [[DataProvider shared] hasMoreData:self.pageIndex]? MJRefreshStateIdle:MJRefreshStateNoMoreData;
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"MoviePosterCell" configuration:^(id cell) {
    }];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    MoviePosterCell *cell        = [tableView dequeueReusableCellWithIdentifier:@"MoviePosterCell"];
    UIImageView     *posterView  = cell.posterView;
    NSString        *urlString   = self.movies[indexPath.row];
    UIImage         *placeholder = [UIImage imageNamed:@"default_focus"];

    [posterView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholder completed:^(UIImage*_Nullable image, NSError*_Nullable error, SDImageCacheType cacheType, NSURL*_Nullable imageURL) {
        if (error) {
            NSLogError(@"%@", error);
        }
    }];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    cell.backgroundColor = indexPath.row % 2? [UIColor whiteColor]:[UIColor grayColor];
};
@end
