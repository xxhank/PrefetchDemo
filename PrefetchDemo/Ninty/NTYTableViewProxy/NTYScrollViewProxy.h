//
//  NTYScrollViewProxy.h
//  SARRS
//
//  Created by wangchao9 on 2017/7/3.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef __FILENAME__
#define __FILENAME__ ({char*ptr = strrchr(__FILE__, '/');if (ptr) {ptr++;} else {ptr = __FILE__;} ptr;})
#endif /* ifndef __FILENAME__ */

#ifndef NTYAssert
#define NTYAssert(condition, desc, ...)             \
    do {                                           \
        if (!(condition)) {                        \
            NSLog(@"%s:%d %s>" desc, __FILENAME__, __LINE__, __FUNCTION__,##__VA_ARGS__);              \
        }                                          \
        NSAssert(condition, desc,##__VA_ARGS__);   \
    } while (0)
#endif /* ifndef NTYAssert */

#define CONNECT_DUMMY_AND_BLOCK(...) \
    Class cls = [self class]; \
    SEL    selector = @selector(dummy_##__VA_ARGS__); \
    Method method   = class_getInstanceMethod(cls,selector); \
    class_addMethod(cls, \
    @selector(__VA_ARGS__), \
    method_getImplementation(method), \
    method_getTypeEncoding(method));

NS_ASSUME_NONNULL_BEGIN
@interface NTYScrollViewProxy : NSObject
#pragma mark - UIScrollViewDelegate
@property (nonatomic,copy) void (^didScroll)(NTYScrollViewProxy *proxy, UIScrollView*scrollView);
@property (nonatomic,copy) void (^didZoom)(NTYScrollViewProxy *proxy, UIScrollView*scrollView);
@property (nonatomic,copy) void (^willBeginDragging)(NTYScrollViewProxy *proxy, UIScrollView*scrollView);
@property (nonatomic,copy) void (^willEndDragging)(NTYScrollViewProxy *proxy, UIScrollView*scrollView, CGPoint velocity,  CGPoint *targetContentOffset);
@property (nonatomic,copy) void (^didEndDragging)(NTYScrollViewProxy *proxy, UIScrollView*scrollView, BOOL decelerate);
@property (nonatomic,copy) void (^willBeginDecelerating)(NTYScrollViewProxy *proxy, UIScrollView*scrollView);
@property (nonatomic,copy) void (^didEndDecelerating)(NTYScrollViewProxy *proxy, UIScrollView*scrollView);
@property (nonatomic,copy) void (^didEndScrollingAnimation)(NTYScrollViewProxy *proxy, UIScrollView*scrollView);
@property (nonatomic,copy) void (^willBeginZooming)(NTYScrollViewProxy *proxy, UIScrollView*scrollView, UIView*__nullable view);
@property (nonatomic,copy) void (^didEndZooming)(NTYScrollViewProxy *proxy, UIScrollView*scrollView, UIView*__nullable view, CGFloat scale);
@property (nonatomic,copy) UIView*(^didScrollToTop)(NTYScrollViewProxy *proxy, UIScrollView*scrollView);
@property (nonatomic,copy) UIView*__nullable (^viewForZooming)(NTYScrollViewProxy *proxy, UIScrollView*scrollView);
@property (nonatomic,copy) BOOL (^shouldScrollToTop)(NTYScrollViewProxy *proxy, UIScrollView*scrollView);
+ (instancetype)proxy:(UIScrollView*)scrollView;
- (instancetype)initWithScrollView:(UIScrollView*)scrollView NS_DESIGNATED_INITIALIZER;
@end
NS_ASSUME_NONNULL_END
