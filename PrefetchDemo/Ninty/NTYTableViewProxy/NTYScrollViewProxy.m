//
//  NTYScrollViewProxy.m
//  SARRS
//
//  Created by wangchao9 on 2017/7/3.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import "NTYScrollViewProxy.h"
#import <objc/runtime.h>

@interface NTYScrollViewProxy () <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation NTYScrollViewProxy
+ (instancetype)proxy:(UIScrollView*)scrollView {
    return [[self alloc] initWithScrollView:scrollView];
}

- (instancetype)init {
    NSAssert(NO, @"call initWithScrollView instead");
    return [self initWithScrollView:[UIScrollView new]];
}

- (instancetype)initWithScrollView:(UIScrollView*)scrollView {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        //scrollView.delegate = self;
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
// any offset changes
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    if (self.didScroll) {
        self.didScroll(self, scrollView);
    }
}

// any zoom scale changes
- (void)scrollViewDidZoom:(UIScrollView*)scrollView {
    if (self.didZoom) {
        self.didZoom(self, scrollView);
    }
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    if (self.willBeginDragging) {
        return self.willBeginDragging(self, scrollView);
    }
}

// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset {
    if (self.willEndDragging) {
        self.willEndDragging(self, scrollView, velocity, targetContentOffset);
    }
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    if (self.didEndDragging) {
        self.didEndDragging(self, scrollView, decelerate);
    }
}

// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView*)scrollView {
    if (self.willBeginDecelerating) {
        self.willBeginDecelerating(self, scrollView);
    }
}

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    if (self.didEndDecelerating) {
        self.didEndDecelerating(self, scrollView);
    }
}
// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView*)scrollView {
    if (self.didEndScrollingAnimation) {
        self.didEndScrollingAnimation(self, scrollView);
    }
}

// called before the scroll view begins zooming its content
- (void)scrollViewWillBeginZooming:(UIScrollView*)scrollView withView:(nullable UIView*)view {
    if (self.willBeginZooming) {
        self.willBeginZooming(self, scrollView, view);
    }
}
// scale between minimum and maximum. called after any 'bounce' animations
- (void)scrollViewDidEndZooming:(UIScrollView*)scrollView withView:(nullable UIView*)view atScale:(CGFloat)scale {
    if (self.didEndZooming) {
        self.didEndZooming(self, scrollView, view, scale);
    }
}

// called when scrolling animation finished. may be called immediately if already at top
- (void)scrollViewDidScrollToTop:(UIScrollView*)scrollView {
    if (self.didScrollToTop) {
        self.didScrollToTop(self, scrollView);
    }
}

#pragma mark - UIScrollViewDelegate Dummy
// return a view that will be scaled. if delegate returns nil, nothing happens
- (nullable UIView*)dummy_viewForZoomingInScrollView:(UIScrollView*)scrollView {
    if (self.viewForZooming) {
        return self.viewForZooming(self, scrollView);
    }
    return nil;
}

// return a yes if you want to scroll to the top. if not defined, assumes YES
- (BOOL)dummy_scrollViewShouldScrollToTop:(UIScrollView*)scrollView {
    if (self.shouldScrollToTop) {
        return self.shouldScrollToTop(self, scrollView);
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate Setter
- (void)setViewForZooming:(UIView*_Nullable (^)(NTYScrollViewProxy*_Nonnull, UIScrollView*_Nonnull))viewForZooming {
    _viewForZooming = viewForZooming;
    CONNECT_DUMMY_AND_BLOCK(viewForZoomingInScrollView:);
}

- (void)setShouldScrollToTop:(BOOL (^)(NTYScrollViewProxy*_Nonnull, UIScrollView*_Nonnull))shouldScrollToTop {
    _shouldScrollToTop = shouldScrollToTop;
    CONNECT_DUMMY_AND_BLOCK(scrollViewShouldScrollToTop:);
}
@end
