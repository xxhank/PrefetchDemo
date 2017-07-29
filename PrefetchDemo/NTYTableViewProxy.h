//
//  NTYTableViewProxy.h
//  NTYTableViewProxyDemo
//
//  Created by wangchao on 2017/6/29.
//  Copyright © 2017年 ibestv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTYSupportViewModel.h"
#import "NTYScrollViewProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface NTYTableViewProxy : NTYScrollViewProxy
#pragma mark ViewModel
@property (nonatomic, strong) NSMutableArray *viewModels;

#pragma mark - UITableViewDataSource

// Default is 1 if not implemented
@property (nonatomic,copy) NSInteger (^numberOfSections)(__kindof NTYTableViewProxy *proxy, UITableView*tableView);

// fixed font style. use custom view (UILabel) if you want something different
@property (nonatomic,copy)   NSString*_Nullable (^titleForHeader)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSInteger section);
@property (nonatomic,copy)   NSString*_Nullable (^titleForFooter)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSInteger section);

#pragma mark Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
@property (nonatomic,copy) BOOL (^canEditRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath);

#pragma mark Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
@property (nonatomic,copy) BOOL (^canMoveRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath);

#pragma mark Index

// return list of section titles to display in section index view (e.g. "ABCD...Z#")
@property (nonatomic,copy)  NSArray<NSString*>*_Nullable (^sectionIndexTitles)(__kindof NTYTableViewProxy*proxy, UITableView*tableView);
// tell table which section corresponds to section title/index (e.g. "B",1))
@property (nonatomic,copy) NSInteger (^sectionForSectionIndexTitle)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSString *title, NSInteger index);;

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
@property (nonatomic,copy) void (^commitEditingStyle)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath);;

// Data manipulation - reorder / moving support
@property (nonatomic,copy) void (^moveRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);;
#pragma mark - UITableViewDelegate
#pragma mark Display customization
@property (nonatomic,copy) void (^willDisplayCell)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);
@property (nonatomic,copy) void (^willDisplayHeaderView)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, UIView *view, NSInteger section) NS_AVAILABLE_IOS(6_0);
@property (nonatomic,copy) void (^willDisplayFooterView)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, UIView *view, NSInteger section) NS_AVAILABLE_IOS(6_0);
@property (nonatomic,copy) void (^didEndDisplayingCell)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, UITableViewCell *cell, NSIndexPath*indexPath) NS_AVAILABLE_IOS(6_0);
@property (nonatomic,copy) void (^didEndDisplayingHeaderView)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, UIView *view, NSInteger section) NS_AVAILABLE_IOS(6_0);
@property (nonatomic,copy) void (^didEndDisplayingFooterView)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, UIView *view, NSInteger section) NS_AVAILABLE_IOS(6_0);

#pragma mark Variable height support

@property (nonatomic,copy) CGFloat (^heightForRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic,copy) CGFloat (^heightForHeader)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSInteger section);
@property (nonatomic,copy) CGFloat (^heightForFooter)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSInteger section);

#pragma mark Estimated Height
// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
@property (nonatomic,copy) CGFloat (^estimatedHeightForRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath) NS_AVAILABLE_IOS(7_0);
@property (nonatomic,copy) CGFloat (^estimatedHeightForHeader)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSInteger section) NS_AVAILABLE_IOS(7_0);
@property (nonatomic,copy) CGFloat (^estimatedHeightForFooter)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSInteger section) NS_AVAILABLE_IOS(7_0);

// Section header & footer information. Views are preferred over title should you decide to provide both

// custom view for header. will be adjusted to default or specified header height
@property (nonatomic,copy)   UIView*_Nullable (^viewForHeader)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSInteger section);
// custom view for footer. will be adjusted to default or specified footer height
@property (nonatomic,copy)   UIView*_Nullable (^viewForFooter)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSInteger section);

#pragma mark Accessories (disclosures).

@property (nonatomic,copy) UITableViewCellAccessoryType (^accessoryTypeForRowWithIndexPath)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath) NS_DEPRECATED_IOS(2_0, 3_0);
@property (nonatomic,copy) void (^accessoryButtonTappedForRowWithIndexPath)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath);

#pragma mark Selection

// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
@property (nonatomic,copy) BOOL (^shouldHighlightRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath) NS_AVAILABLE_IOS(6_0);
@property (nonatomic,copy) void (^didHighlightRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath) NS_AVAILABLE_IOS(6_0);
@property (nonatomic,copy) void (^didUnhighlightRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath) NS_AVAILABLE_IOS(6_0);

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
@property (nonatomic,copy) NSIndexPath*_Nullable (^willSelectRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic,copy) NSIndexPath*_Nullable (^willDeselectRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath) NS_AVAILABLE_IOS(3_0);
// Called after the user changes the selection.
@property (nonatomic,copy) void (^didSelectRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic,copy) void (^didDeselectRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath) NS_AVAILABLE_IOS(3_0);

#pragma mark Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
@property (nonatomic,copy) UITableViewCellEditingStyle (^editingStyleForRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic,copy) NSString                      *_Nullable (^titleForDeleteConfirmationButtonForRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath) NS_AVAILABLE_IOS(3_0);
// supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
@property (nonatomic,copy) NSArray<UITableViewRowAction*>*_Nullable (^editActionsForRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath) NS_AVAILABLE_IOS(8_0);

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
@property (nonatomic,copy) BOOL (^shouldIndentWhileEditingRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath);

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
@property (nonatomic,copy) void (^willBeginEditingRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic,copy) void (^didEndEditingRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath*_Nullable indexPath);

#pragma mark Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
@property (nonatomic,copy) NSIndexPath*(^targetIndexPathForMoveFromRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *sourceIndexPath, NSIndexPath *proposedDestinationIndexPath);;

#pragma mark Indentation

// return 'depth' of row for hierarchies
@property (nonatomic,copy) NSInteger (^indentationLevelForRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath);

#pragma mark Copy/Paste.  All three methods must be implemented by the delegate.

@property (nonatomic,copy) BOOL (^shouldShowMenuForRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath) NS_AVAILABLE_IOS(5_0);
@property (nonatomic,copy) BOOL (^canPerformAction)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, SEL action, NSIndexPath *indexPath, id _Nullable sender) NS_AVAILABLE_IOS(5_0);
@property (nonatomic,copy) void (^performAction)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, SEL action, NSIndexPath *indexPath, id _Nullable sender) NS_AVAILABLE_IOS(5_0);

#pragma mark Focus
@property (nonatomic,copy) BOOL (^canFocusRow)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath) NS_AVAILABLE_IOS(9_0);
@property (nonatomic,copy) BOOL (^shouldUpdateFocusInContext)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, UITableViewFocusUpdateContext *context) NS_AVAILABLE_IOS(9_0);
@property (nonatomic,copy) void (^didUpdateFocusInContext)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, UITableViewFocusUpdateContext *context, UIFocusAnimationCoordinator *coordinator) NS_AVAILABLE_IOS(9_0);
@property (nonatomic,copy) NSIndexPath*_Nullable (^indexPathForPreferredFocusedView)(__kindof NTYTableViewProxy *proxy, UITableView*tableView) NS_AVAILABLE_IOS(9_0);

#pragma mark - click cell component
@property (nonatomic,copy) void (^didSelectRowComponent)(__kindof NTYTableViewProxy *proxy, UITableView *tableView, NSIndexPath *indexPath, id context);
@property (nonatomic,copy) void (^didSelectHeaderView)(__kindof NTYTableViewProxy *proxy, UITableViewHeaderFooterView *view, NSInteger section, id context);
@property (nonatomic,copy) void (^didSelectFooterView)(__kindof NTYTableViewProxy *proxy, UITableViewHeaderFooterView *view, NSInteger section, id context);

+ (NSString*)reuseIdentifierFromCellViewModel:(id)viewModel;
+ (NSString*)reuseIdentifierFromReuseViewViewModel:(id<NTYReuseViewViewModel>)viewModel;
+ (instancetype)proxy:(UITableView*)tableView;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTableView:(UITableView*)tableView NS_DESIGNATED_INITIALIZER;

- (void)perform:(void(^__nonnull)(__kindof NTYTableViewProxy*__nonnull proxy))action completion:(void(^__nonnull)(void))completion;

+ (NSArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths from:(NSMutableArray*)viewModels;
#pragma mark - Update
- (void)updateViewModels:(__kindof NSArray<NTYTableViewCellViewModelType>*)viewModels;

- (void)appendViewModels:(__kindof NSArray<NTYTableViewCellViewModelType>*)viewModels;
- (void)appendViewModels:(__kindof NSArray<NTYTableViewCellViewModelType>*)viewModels rowAnimation:(UITableViewRowAnimation)animation;
- (void)appendViewModels:(__kindof NSArray<NTYTableViewCellViewModelType>*)viewModels updateViewModels:(BOOL)updateViewModels rowAnimation:(UITableViewRowAnimation)animation;

- (void)insertViewModels:(__kindof NSArray<NTYTableViewCellViewModelType>*)viewModels atIndexPaths:(NSArray<NSIndexPath*>*)indexPaths;
- (void)insertViewModels:(__kindof NSArray<NTYTableViewCellViewModelType>*)viewModels atIndexPaths:(NSArray<NSIndexPath*>*)indexPaths rowAnimation:(UITableViewRowAnimation)animation;
- (void)insertViewModels:(NSArray<NTYTableViewCellViewModelType>*)viewModels atIndexPaths:(NSArray*)indexPaths updateViewModels:(BOOL)updateViewModels rowAnimation:(UITableViewRowAnimation)animation;

- (NSArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths;
- (NSArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths rowAnimation:(UITableViewRowAnimation)animation;
- (NSArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths updateViewModels:(BOOL)updateViewModels rowAnimation:(UITableViewRowAnimation)animation;
#pragma mark - Query
- (nullable NSArray<NTYTableViewCellViewModelType>*)cellViewModelsForSection:(NSInteger)section;
- (nullable __kindof NTYTableViewCellViewModelType)viewModelForRow:(NSIndexPath*)indexPath;
@end

@interface NTYSectionTableViewProxy : NTYTableViewProxy
+ (instancetype)proxy:(UITableView*)tableView customHeaderFooterView:(BOOL)customHeaderFooterView;
+ (NSArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths from:(NSMutableArray*)viewModels;
#pragma mark - Update
#pragma mark section
- (void)appendViewModels:(__kindof NSArray<NTYTableViewSectionViewModelType>*)viewModels;
- (void)appendViewModels:(__kindof NSArray<NTYTableViewSectionViewModelType>*)viewModels rowAnimation:(UITableViewRowAnimation)animation;
- (void)appendViewModels:(__kindof NSArray<NTYTableViewSectionViewModelType>*)viewModels updateViewModels:(BOOL)updateViewModels rowAnimation:(UITableViewRowAnimation)animation;

- (void)insertViewModels:(NSArray*)viewModels atSections:(NSArray<NSNumber*>*)sections;
- (void)insertViewModels:(NSArray*)viewModels atSections:(NSArray<NSNumber*>*)sections rowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadViewModelsAtSection:(NSUInteger)section;
- (void)reloadViewModelsAtSection:(NSUInteger)section rowAnimation:(UITableViewRowAnimation)animation;
#pragma mark rows
- (void)updateViewModels:(__kindof NSArray<NTYTableViewSectionViewModelType >*)viewModels;

- (void)appendViewModels:(__kindof NSArray<NTYTableViewCellViewModelType>*)viewModels inSection:(NSUInteger)section;
- (void)appendViewModels:(__kindof NSArray<NTYTableViewCellViewModelType>*)viewModels inSection:(NSUInteger)section rowAnimation:(UITableViewRowAnimation)animation;

- (void)insertViewModels:(__kindof NSArray<NTYTableViewCellViewModelType>*)viewModels atIndexPaths:(NSArray<NSIndexPath*>*)indexPaths;
- (void)insertViewModels:(__kindof NSArray<NTYTableViewCellViewModelType>*)viewModels atIndexPaths:(NSArray<NSIndexPath*>*)indexPaths rowAnimation:(UITableViewRowAnimation)animation;
#pragma mark - Query
- (nullable __kindof NTYTableViewSectionViewModelType)viewModelForSection:(NSInteger)section;
- (id<NTYTableViewHeaderFooterViewViewModel>)headerViewModelForSection:(NSInteger)section;
- (id<NTYTableViewHeaderFooterViewViewModel>)footerViewModelForSection:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
