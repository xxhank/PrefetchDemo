//
//  SASTableViewController.h
//  Le123PhoneClient
//
//  Created by dhl on 2017/5/27.
//  Copyright © 2017年 Ying Shi Da Quan. All rights reserved.
//

#import "SASViewController.h"
#import "NTYTableViewProxy.h"

@interface SASTableViewController : SASViewController
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NTYTableViewProxy    *proxy;

#pragma mark - support subclassing
- (UITableView*)buildTableView;
- (NTYTableViewProxy*)buildTableViewProxy;

#pragma mark - header/footer
/**
 *  是否允许下拉刷新控件
 */
@property (nonatomic, assign) BOOL refreshHeaderEnabled;
/**
 *  是否允许上拉更多控件
 */
@property (nonatomic, assign) BOOL refreshFooterEnabled;

/**
 *  通知下拉刷新完成
 *
 *  @param hasMoreData 是否还有更多的数据
 */
- (void)loadNewDataFinished:(BOOL)hasMoreData;

/**
 *  通知上拉加载更多完成
 *
 *  @note 预加载也是上拉加载更多的一种形式
 *  @param hasMoreData 是否还有更多的数据
 */
- (void)loadMoreDataFinished:(BOOL)hasMoreData;

#pragma mark - header/footer subclassing
/**
 *  加载新数据, 子类实现具体的行为
 *  @note 子类重载时需要调用 [super loadNewData];
 *  @code
   - (void)loadNewData {
   [super loadNewData];

   /// other code
   }
 *  @endcode
 */
- (void)loadNewData;

/**
 *  加载更多数据, 子类实现具体的行为
 *  @note 子类重载时需要调用 [super loadNewData];
 *  @param prefetch 是否又预加载触发
 *  @code
   - (void)loadMoreData:(BOOL)prefetch {
    /// check can load more

    [super loadMoreData:prefetch];

    /// load more
   }
 *  @endcode
 */
- (void)loadMoreData:(BOOL)prefetch;

#pragma mark - prefetch
/**
 *  预加载数据的行数阈值
 */
@property (nonatomic, assign) NSUInteger prefetchRowDistance;
/**
 *  预加载数据的偏移量阈值, 是当前一屏内容高度的比例
 */
@property (nonatomic, assign) CGFloat prefetchOffsetPrecent;

/**
 *  检测scrollView的偏移量,并预加载数据
 *
 *  @param scrollView 需要预加载的view
    @code
   - (void)scrollViewDidScroll:(UIScrollView*)scrollView {
      [self prefetchByCheckOffset:scrollView];
   }
    @endcode
 */
- (void)prefetchByCheckOffset:(UIScrollView*)scrollView;

/**
 *  检测当前显示的cell的indexPaths,并预加载数据
 *
 *  @param indexPath 将要显示的cell的位置
 *  @code
   - (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    /// other code
   [self prefetchByCheckIndexPath:indexPath];
   };
 *  @endcode
 */
- (void)prefetchByCheckIndexPath:(NSIndexPath*)indexPath;
/**
 *  停止预加载, 需要子类实现该行为
 *  @note 子类重载时需要调用 [super cancelPrefetch]
 *  @code
   - (void)cancelPrefetch{
    /// cancel request code

    [super cancelPrefetch];
   }
   @endcode
 */
- (void)cancelPrefetch;
@end
