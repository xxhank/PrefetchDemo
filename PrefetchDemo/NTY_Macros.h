//
//  DQMacro.h
//  Le123PhoneClient
//
//  Created by caoyu on 2017/6/17.
//  Copyright © 2017年 Ying Shi Da Quan. All rights reserved.
//

#pragma once

#pragma mark - Device
//Platform
#define IS_IPHONE UIUserInterfaceIdiomPhone == [[UIDevice currentDevice] userInterfaceIdiom]
#define IS_IPAD   UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom]

//Version
#define IOS_7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#pragma mark - APP
#define NTYAppVersion [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]

#pragma mark - UserDefault
#define UserDefault [NSUserDefaults standardUserDefaults]

#pragma mark - UIColor
#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed: (float)(r) / 255.0 green: (float)(g) / 255.0 blue: (float)(b) / 255.0 alpha: a]
#define COLOR_RGB(r,g,b)    COLOR_RGBA(r, g, b, 1)
#define COLOR_HEX(hex)      COLOR_RGB(((hex) & 0xFF0000) >> 16,((hex) & 0xFF00) >> 8,((hex) & 0xFF))
#define COLOR_HEXA(hex,a)   COLOR_RGBA(((hex) & 0xFF0000) >> 16,((hex) & 0xFF00) >> 8,((hex) & 0xFF), a)


#define RGBCOLOR(r,g,b)    [UIColor colorWithRed: (r) / 255.0f green: (g) / 255.0f blue: (b) / 255.0f alpha : 1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed: (r) / 255.0f green: (g) / 255.0f blue: (b) / 255.0f alpha: (a)]

#define RGBCOLOR_HEX(h)    RGBCOLOR((((h) >> 16) & 0xFF), (((h) >> 8) & 0xFF), ((h) & 0xFF))
#define RGBACOLOR_HEX(h,a) RGBACOLOR((((h) >> 16) & 0xFF), (((h) >> 8) & 0xFF), ((h) & 0xFF), (a))

#pragma mark - UIScreen
#define SCREEN_SCALE  [UIScreen mainScreen].scale
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#pragma mark - CGRect
#define RECT(x,y,w,h)     CGRectMake(x,y,w,h)
#define RECT_WIDTH(rect)  CGRectGetWidth(rect)
#define RECT_HEGIHT(rect) CGRectGetHeight(rect)

#define RECT_LEFT(rect)   CGRectGetMinX(rect)
#define RECT_TOP(rect)    CGRectGetMinY(rect)
#define RECT_RIGHT(rect)  CGRectGetMaxX(rect)
#define RECT_BOTTOM(rect) CGRectGetMaxY(rect)

#define RECT_CENTER_X(rect) CGRectGetMidX(rect)
#define RECT_CENTER_Y(rect) CGRectGetMidY(rect)

#pragma mark - CGSize
#define SIZE(w,h) CGSizeMake(w,h)

#pragma mark - CGPoint
#define POINT(x,y) CGPointMake(x,y)

#pragma mark - UIEdgeInsets
#define INSETS(t,l,b,r) UIEdgeInsetsMake(t,l,b,r)

#pragma mark - UIOffset
#define OFFSET(horizontal,vertical) UIOffsetMake(horizontal, vertical)

#pragma mark - NSString
#define STRING(fmt, ...) [NSString stringWithFormat: fmt,##__VA_ARGS__]

#pragma mark - NSIndexPath
#define INDEXPATH(section, row) [NSIndexPath indexPathForRow: row inSection: section]

#pragma mark - FILENAME
#ifndef __FILENAME__
#define __FILENAME__ ({(strrchr(__FILE__, '/')?:(__FILE__ - 1)) + 1;})
#endif // ifndef __FILENAME__

#pragma mark - Nil|Null
#define isNilOrNull(obj)                                                                                       \
    ({                                                                                                         \
        BOOL invalid = NO;                                                                                     \
        if (!obj || (NSNull*)obj == [NSNull null]) {                                                           \
            invalid = YES;                                                                                     \
        } else {                                                                                               \
            NSString *temp = [[NSString alloc] initWithFormat:@"%@",obj];                                      \
            invalid = [temp containsString:@"null"] || [temp containsString:@"nil"] || [temp containsString:@"NSNull"]; \
        }                                                                                                      \
        invalid;                                                                                               \
    })

#pragma mark -Signalton
#if __has_feature(objc_arc)
#define SINGLETON_DECL(classname) \
    + (classname*)shared;

#define SINGLETON_IMPL(classname) \
    static classname * shared##classname = nil; \
    + (classname*)shared \
    { \
        static dispatch_once_t pred; \
        dispatch_once(&pred, ^{shared##classname = [[classname alloc] init];}); \
        return shared##classname; \
    }

#else // if __has_feature(objc_arc)

#define SINGLETON_DECL(classname) \
    + (classname*)shared;

#define SINGLETON_IMPL(classname) \
    static classname * shared##classname = nil; \
    + (classname*)shared \
    { \
        static dispatch_once_t pred; \
        dispatch_once(&pred, ^{shared##classname = [[classname alloc] init];}); \
        return shared##classname; \
    } \
    - (id)copyWithZone:(NSZone*)zone \
    { \
        return self; \
    } \
    - (id)retain \
    { \
        return self; \
    } \
    - (NSUInteger)retainCount \
    { \
        return NSUIntegerMax; \
    } \
    - (oneway void)release \
    { \
    } \
    - (id)autorelease \
    { \
        return self; \
    }
#endif // if __has_feature(objc_arc)

#pragma mark - Category
/// 引用自YYKit
/**
   Add this macro before each category implementation, so we don't have to use
   -all_load or -force_load to load object files from static libraries that only
   contain categories and no classes.
   More info: http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html .
 *******************************************************************************
   Example:
   NTY_DUMMY_CLASS(NSString_Add)
 */
#ifndef NTY_DUMMY_CLASS
#define NTY_DUMMY_CLASS(_name_) \
    @interface NTY_DUMMY_CLASS_##_name_ : NSObject @end \
    @implementation NTY_DUMMY_CLASS_##_name_ @end
#endif // ifndef YYSYNTH_DUMMY_CLASS

/**
   Synthsize a dynamic object property in @implementation scope.
   It allows us to add custom properties to existing classes in categories.

   @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
   @warning #import <objc/runtime.h>
 *******************************************************************************
   Example:
   @interface NSObject (MyAdd)
   @property (nonatomic, retain) UIColor *myColor;
   @end
 # import <objc/runtime.h>
   @implementation NSObject (MyAdd)
   NTY_ASSOCIATE_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
   @end
 */
#ifndef NTY_ASSOCIATE_OBJECT
#define NTY_ASSOCIATE_OBJECT(_getter_, _setter_, _association_, _type_) \
    - (void)_setter_: (_type_)object { \
        [self willChangeValueForKey:@#_getter_]; \
        objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_##_association_); \
        [self didChangeValueForKey:@#_getter_]; \
    } \
    - (_type_)_getter_ { \
        return objc_getAssociatedObject(self, @selector(_setter_:)); \
    }
#endif // ifndef NTY_ASSOCIATE_OBJECT


#ifndef NTY_ASSOCIATE_VALUE
#define NTY_ASSOCIATE_VALUE(_getter_, _setter_, _type_) \
    - (void)_setter_: (_type_)object { \
        [self willChangeValueForKey:@#_getter_]; \
        NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
        objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
        [self didChangeValueForKey:@#_getter_]; \
    } \
    - (_type_)_getter_ { \
        _type_   cValue = {0}; \
        NSValue *value  = objc_getAssociatedObject(self, @selector(_setter_:)); \
        [value getValue:&cValue]; \
        return cValue; \
    }
#endif // ifndef NTY_ASSOCIATE_VALUE

#pragma mark -

/*
   NSLocalizedDescriptionKey: NSString
   NSUnderlyingErrorKey: NSError
   NSLocalizedFailureReasonErrorKey:  NSString
   NSLocalizedRecoverySuggestionErrorKey:  NSString
   NSLocalizedRecoveryOptionsErrorKey:  NSArray<NSStrings*>
   NSRecoveryAttempterErrorKey:NSObject<NSErrorRecoveryAttempting>
   NSHelpAnchorErrorKey NSString containing a help anchor
 */
#define NTYError(_code_, _description_,...) \
    [NSError errorWithDomain: NSStringFromClass([self class]) code: _code_ userInfo: @{NSLocalizedDescriptionKey:_description_,##__VA_ARGS__}]
#define NTYError1(_domain_, _code_, _description_,...) \
    [NSError errorWithDomain: _domain_ code: _code_ userInfo: @{NSLocalizedDescriptionKey:_description_,##__VA_ARGS__}]

#pragma mark - Control Flow
#define NTYGuard(condition) \
    if (!(condition)) { \
        NSLogWarn(@"return for: %@ failed",@#condition); \
        return; \
    }

#define NTYRGuard(condition, ret) \
    if (!(condition)) { \
        NSLogWarn(@"return "__VA_ARGS__ @" for: %@ failed",@#condition); \
        return (ret); \
    }

#pragma mark - NTYAssert
#define NTYAssert(condition, desc, ...)             \
    if (!(condition)) {                             \
        NSLogError(desc,##__VA_ARGS__);             \
        NSAssert(condition, desc,##__VA_ARGS__);    \
        return;                                     \
    }                                               \

#define NTYAssertNil(a)                                         \
    if (!((a) == nil)) {                                        \
        NSLogError(@"%@ must be nil.", @#a);                    \
        NSAssert((a) == nil, @"%@ must be nil.", @#a);           \
        return;                                                 \
    }                                                           \

#define NTYAssertNotNil(a)                                      \
    if (!((a) != nil)) {                                        \
        NSLogError(@"%@ must not be nil.", @#a);                \
        NSAssert((a) != nil, @"%@ must not be nil.", @#a);       \
        return;                                                 \
    }                                                           \

#define NTYAssertEqual(a,b)                                     \
    if (!((a) != nil && (b) != nil && ((a) == (b)))) {          \
        NSLogError(@"%@ must euqal to %@.", (a), (b));          \
        NSAssert((a) != nil && (b) != nil && ((a) == (b)), @"%@ must euqal to %@.", (a), (b)); \
        return;                                                 \
    }                                                           \

#define NTYAssertMustSubclassing() \
    NTYAssert(NO, @"%@ must implement %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd));

#pragma mark - NTYAssert Has Return Valie
#define NTYRAssert(condition, ret, desc, ...)       \
    if (!(condition)) {                             \
        NSLogError(desc,##__VA_ARGS__);             \
        NSAssert(condition, desc,##__VA_ARGS__);    \
        return (ret);                               \
    }                                               \

#define NTYRAssertNil(a, ret)                                   \
    if (!((a) == nil)) {                                        \
        NSLogError(@"%@ must be nil.", @#a);                    \
        NSAssert((a) == nil, @"%@ must be nil.", @#a);           \
        return (ret);                                           \
    }                                                           \

#define NTYRAssertNotNil(a,ret)                                     \
    if (!((a) != nil)) {                                        \
        NSLogError(@"%@ must not be nil.", @#a);                \
        NSAssert((a) != nil, @"%@ must not be nil.", @#a);       \
        return (ret);                                           \
    }                                                           \

#define NTYRAssertEqual(a,b,ret)                                 \
    if (!(((a) != nil && (b) != nil && ((a) == (b))))) {         \
        NSLogError(@"%@ must euqal to %@.", (a), (b));           \
        NSAssert(((a) != nil && (b) != nil && ((a) == (b))), @"%@ must euqal to %@.", (a), (b));  \
        return (ret);                                            \
    }                                                            \

#define NTYRAssertMustSubclassing(ret) \
    NTYRAssert(NO, ret, @"%@ must implement %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd));

#pragma mark - Notification

#ifdef __IPHONE_8_0
#define RemoteNotificationTypeAlert UIUserNotificationTypeAlert
#define RemoteNotificationTypeBadge UIUserNotificationTypeBadge
#define RemoteNotificationTypeSound UIUserNotificationTypeSound
#define RemoteNotificationTypeNone  UIUserNotificationTypeNone
#else // ifdef __IPHONE_8_0
#define RemoteNotificationTypeAlert UIRemoteNotificationTypeAlert
#define RemoteNotificationTypeBadge UIRemoteNotificationTypeBadge
#define RemoteNotificationTypeSound UIRemoteNotificationTypeSound
#define RemoteNotificationTypeNone  UIRemoteNotificationTypeNone
#endif // ifdef __IPHONE_8_0

#pragma mark - safe progaming
#define IVAR_TO_LOCAL(ivar, local) __strong typeof(ivar)local = ivar

// UITableView register NIB
#pragma mark - UITableView

#define TABLEVIEW_REGISTER_CELL_NIB(tableView,...) \
    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(TABLEVIEW_REGISTER_CELL_NIB1(tableView,__VA_ARGS__))(TABLEVIEW_REGISTER_CELL_NIB2(tableView, __VA_ARGS__))

#define TABLEVIEW_REGISTER_CELL_NIB1(tableView, nibName) \
    do { \
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil]; \
        [tableView registerNib:nib forCellReuseIdentifier:nibName]; \
    } while (0);

#define TABLEVIEW_REGISTER_CELL_NIB2(tableView, nibName, reuseIdentifier) \
    do { \
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil]; \
        [tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier]; \
    } while (0);

#define TABLEVIEW_REGISTER_CELL_CLASS(tableView,...) \
    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(TABLEVIEW_REGISTER_CELL_CLASS1(tableView, __VA_ARGS__))(TABLEVIEW_REGISTER_CELL_CLASS2(tableView,__VA_ARGS__))
#define TABLEVIEW_REGISTER_CELL_CLASS1(tableView, className) \
    [tableView registerClass:[className class] forCellReuseIdentifier: @#className]
#define TABLEVIEW_REGISTER_CELL_CLASS2(tableView, className, reuseIdentifier) \
    [tableView registerClass:[className class] forCellReuseIdentifier: reuseIdentifier]


#define TABLEVIEW_REGISTER_VIEW_NIB(tableView,...) \
    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(TABLEVIEW_REGISTER_VIEW_NIB1(tableView,__VA_ARGS__))(TABLEVIEW_REGISTER_VIEW_NIB2(tableView, __VA_ARGS__))

#define TABLEVIEW_REGISTER_VIEW_NIB1(tableView, nibName) \
    do { \
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil]; \
        [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:nibName]; \
    } while (0)

#define TABLEVIEW_REGISTER_VIEW_NIB2(tableView, nibName, reuseIdentifier) \
    do { \
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil]; \
        [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:reuseIdentifier]; \
    } while (0)


#pragma mark - UICollectionView

#define COLLECTIONVIEW_REGISTER_CELL_NIB(collectionView,...) \
    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(COLLECTIONVIEW_REGISTER_CELL_NIB1(collectionView,__VA_ARGS__))(COLLECTIONVIEW_REGISTER_CELL_NIB2(collectionView, __VA_ARGS__))

#define COLLECTIONVIEW_REGISTER_CELL_NIB1(collectionView, nibName) \
    [collectionView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier: nibName]
#define COLLECTIONVIEW_REGISTER_CELL_NIB2(collectionView, nibName, reuseIdentifier) \
    [collectionView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier: reuseIdentifier]

#define COLLECTIONVIEW_REGISTER_CELL_CLASS(collectionView,...) \
    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(COLLECTIONVIEW_REGISTER_CELL_CLASS1(collectionView, __VA_ARGS__))(COLLECTIONVIEW_REGISTER_CELL_CLASS2(collectionView,__VA_ARGS__))
#define COLLECTIONVIEW_REGISTER_CELL_CLASS1(collectionView, className) \
    [collectionView registerClass:[className class] forCellWithReuseIdentifier: @#className]
#define COLLECTIONVIEW_REGISTER_CELL_CLASS2(collectionView, className, reuseIdentifier) \
    [collectionView registerClass:[className class] forCellWithReuseIdentifier: reuseIdentifier]

#define COLLECTIONVIEW_REGISTER_VIEW_NIB(collectionView, kind, ...) \
    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(COLLECTIONVIEW_REGISTER_VIEW_NIB1(collectionView,__VA_ARGS__))(COLLECTIONVIEW_REGISTER_VIEW_NIB2(collectionView, __VA_ARGS__))

#define COLLECTIONVIEW_REGISTER_VIEW_NIB1(collectionView, kind, nibName) \
    do { \
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil]; \
        [collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSection##kind withReuseIdentifier:nibName]; \
    } while (0)

#define COLLECTIONVIEW_REGISTER_VIEW_NIB2(collectionView, kind, nibName, reuseIdentifier) \
    do { \
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil]; \
        [collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSection##kind withReuseIdentifier:reuseIdentifier]; \
    } while (0)

#define COLLECTIONVIEW_REGISTER_HEADER_CLASS(collectionView,className,reuseIdentifier) \
    [collectionView registerClass:[className class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: reuseIdentifier]

#define COLLECTIONVIEW_REGISTER_FOOTER_CLASS(collectionView,className,reuseIdentifier) \
    [collectionView registerClass:[className class] forSupplementaryViewOfKind: UICollectionElementKindSectionFooter withReuseIdentifier: reuseIdentifier]
