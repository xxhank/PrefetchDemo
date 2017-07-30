//
//  NTYTableViewProxy.m
//  NTYTableViewProxyDemo
//
//  Created by wangchao on 2017/6/29.
//  Copyright © 2017年 ibestv. All rights reserved.
//

#import "NTYTableViewProxy.h"
#import <objc/runtime.h>
#import "NSArray+NTYExtension.h"
#import "NTYTableViewCell.h"
#import "NTYTableViewHeaderFooterView.h"
#import "UITableViewCell+NTYExtension.h"
#import "NTY_Macros.h"
#import <libextobjc/EXTScope.h>
@interface NTYTableViewProxy ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation NTYTableViewProxy
+ (instancetype)proxy:(UITableView*)tableView {
    return [[self alloc] initWithTableView:tableView];
}

#pragma mark - help
+ (NSString*)reuseIdentifierFromCellViewModel:(NTYTableViewCellViewModelType)viewModel {
    NSString *reuseIdentifier = nil;

    /// 获取Cell的重用ID
    if ([viewModel respondsToSelector:@selector(reuseIdentifier)]) {
        reuseIdentifier = [viewModel reuseIdentifier];
    } else {
        /// 根据ViewModel类型,获取Cell的重用ID
        NSString*className = NSStringFromClass([viewModel class]);
        className = [className stringByReplacingOccurrencesOfString:@"ViewModelImpl" withString:@""];
        className = [className stringByReplacingOccurrencesOfString:@"ViewModel" withString:@""];
        if ([className hasSuffix:@"Cell"]) {
            reuseIdentifier = className;
        } else {
            reuseIdentifier = [NSString stringWithFormat:@"%@Cell", className];
        }
    }

    return reuseIdentifier;
}

+ (NSString*)reuseIdentifierFromReuseViewViewModel:(id<NTYReuseViewViewModel>)viewModel {
    NSString *reuseIdentifier = nil;

    /// 通过方法获取重用ID
    if ([viewModel respondsToSelector:@selector(reuseIdentifier)]) {
        reuseIdentifier = [viewModel reuseIdentifier];
    } else {
        /// 根据命名规则,替换ViewModel类型名称中的特殊标记
        NSString*className = NSStringFromClass([viewModel class]);
        className       = [className stringByReplacingOccurrencesOfString:@"ViewModelImpl" withString:@""];
        className       = [className stringByReplacingOccurrencesOfString:@"ViewModel" withString:@""];
        reuseIdentifier = className;
    }

    return reuseIdentifier;
}

/**
 *  根据indexPaths生成NSIndexSet
 *
 *  @param indexPaths NSIndexPath数组, 数组中NSIndexPath的section必须相同
 *
 *  @return NSMutableIndexSet对象
 */
+ (NSMutableIndexSet*)indexSetFromIndexPaths:(NSArray<NSIndexPath*>*)indexPaths {
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
    [indexPaths nty_each:^(NSIndexPath*item, NSUInteger index) {
        [set addIndex:[item row]];
    }];
    return set;
}

- (instancetype)initWithScrollView:(UIScrollView*)scrollView {
    NSAssert(NO, @"call initWithTableView instead");
    return [self initWithTableView:[UITableView new]];
}

- (instancetype)initWithTableView:(UITableView*)tableView {
    self = [super initWithScrollView:tableView];
    if (self) {
        _tableView = tableView;
    }
    return self;
}

#pragma mark - Update
+ (NSArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths from:(NSMutableArray<NTYTableViewCellViewModelType>*)cellViewModels {
    NSIndexSet *set = [[self class] indexSetFromIndexPaths:indexPaths];
    [cellViewModels removeObjectsAtIndexes:set];
    return indexPaths;
}

- (void)updateViewModels:(NSArray*)viewModels {
    self.viewModels           = viewModels.mutableCopy;
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self.tableView reloadData];
}

- (void)appendViewModels:(NSArray*)viewModels {
    [self appendViewModels:viewModels rowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)appendViewModels:(NSArray*)viewModels rowAnimation:(UITableViewRowAnimation)animation {
    [self appendViewModels:viewModels updateViewModels:YES rowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)appendViewModels:(NSArray*)viewModels updateViewModels:(BOOL)updateViewModels rowAnimation:(UITableViewRowAnimation)animation {
    NSInteger base       = self.viewModels.count;
    NSArray  *indexPaths = [viewModels nty_map:^id (id obj, NSUInteger idx) {
        return [NSIndexPath indexPathForRow:base + idx inSection:0];
    }];
    [self.tableView beginUpdates];
    if (updateViewModels) {
        [self.viewModels addObjectsFromArray:viewModels];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self.tableView endUpdates];
}

- (void)perform:(void(^__nonnull)(__kindof NTYTableViewProxy*__nonnull proxy))action completion:(void(^__nonnull)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    if (action) {
        action(self);
    }
    [CATransaction commit];
}

/**
 *  插入元素
 *
 *  @param viewModels 视图模型数组
 *  @param indexPaths NSIndexPaths数组
 *  @note indexPaths必须从小到大排序,切viewModels和indexPaths同顺序
 */
- (void)insertViewModels:(NSArray*)viewModels atIndexPaths:(NSArray*)indexPaths {
    [self insertViewModels:viewModels atIndexPaths:indexPaths rowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertViewModels:(NSArray*)viewModels atIndexPaths:(NSArray*)indexPaths rowAnimation:(UITableViewRowAnimation)animation {
    [self insertViewModels:viewModels atIndexPaths:indexPaths updateViewModels:YES rowAnimation:animation];
}
- (void)insertViewModels:(NSArray*)viewModels atIndexPaths:(NSArray*)indexPaths updateViewModels:(BOOL)updateViewModels rowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet*set = [[self class] indexSetFromIndexPaths:indexPaths];
    [self.tableView beginUpdates];
    if (updateViewModels) {
        [self.viewModels insertObjects:viewModels atIndexes:set];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self.tableView endUpdates];
}


- (NSArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths {
    return [self removeViewModelsAtIndexPaths:indexPaths rowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths rowAnimation:(UITableViewRowAnimation)animation {
    return [self removeViewModelsAtIndexPaths:indexPaths updateViewModels:YES rowAnimation:animation];
}

- (NSArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths updateViewModels:(BOOL)updateViewModels rowAnimation:(UITableViewRowAnimation)animation {
    [self.tableView beginUpdates];
    NSArray *removedIndexPaths = indexPaths;
    if (updateViewModels) {
        removedIndexPaths = [[self class] removeViewModelsAtIndexPaths:indexPaths from:self.viewModels];
    }
    [self.tableView deleteRowsAtIndexPaths:removedIndexPaths withRowAnimation:animation];
    [self.tableView endUpdates];
    return removedIndexPaths;
}

#pragma mark - Query
- (NSArray*)cellViewModelsForSection:(NSInteger)section {
    return self.viewModels;
}

- (id)viewModelForRow:(NSIndexPath*)indexPath {
    return self.viewModels[indexPath.row];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self cellViewModelsForSection:section].count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    id       viewModel       = [self viewModelForRow:indexPath];
    NSString*reuseIdentifier = [[self class] reuseIdentifierFromCellViewModel:viewModel];
    id       cell            = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    NTYRAssert(cell, [UITableViewCell defaultStyleCell:reuseIdentifier], @"call register(Nib|Class):forCellReuseIdentifier:%@", reuseIdentifier);
    [cell setClipsToBounds:YES];
    if ([cell respondsToSelector:@selector(setViewModel:)]) {
        [cell setViewModel:viewModel];
    }

    if (self.didSelectRowComponent && [cell respondsToSelector:@selector(setClickComponent:)]) {
        @weakify(self, tableView);
        [cell setClickComponent:^(UITableViewCell*cell, id context) {
            @strongify(self, tableView);
            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
            self.didSelectRowComponent(self, tableView, indexPath, context);
        }];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.heightForRow) {
        return self.heightForRow(self, tableView, indexPath);
    }

    id<NTYTableViewCellViewModel> viewModel = [self viewModelForRow:indexPath];
    if ([viewModel respondsToSelector:@selector(cellHeight)]) {
        CGFloat cellHeight = [viewModel cellHeight];
        if (fabs(cellHeight) > 0.000001) {
            return cellHeight;
        }
    }
    NSString *reuseIdentifier = [[self class] reuseIdentifierFromCellViewModel:viewModel];
    CGFloat   height          = [tableView fd_heightForCellWithIdentifier:reuseIdentifier configuration:^(id cell) {
        if ([cell respondsToSelector:@selector(setViewModel:)]) {
            [cell setViewModel:viewModel];
        }
    }];

    return height;
}

- (CGFloat)tableView:(UITableView*)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.estimatedHeightForRow) {
        return self.estimatedHeightForRow(self, tableView, indexPath);
    }
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource-Dummy
// Default is 1 if not implemented
- (NSInteger)dummy_numberOfSectionsInTableView:(UITableView*)tableView {
    if (self.numberOfSections) {
        return self.numberOfSections(self, tableView);
    }
    return 1;
}

// fixed font style. use custom view (UILabel) if you want something different
- (nullable NSString*)dummy_tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.titleForHeader) {
        return self.titleForHeader(self, tableView, section);
    }
    return nil;
}

- (nullable NSString*)dummy_tableView:(UITableView*)tableView titleForFooterInSection:(NSInteger)section {
    if (self.titleForFooter) {
        return self.titleForFooter(self, tableView, section);
    }
    return nil;
}

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)dummy_tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.canEditRow) {
        return self.canEditRow(self, tableView, indexPath);
    }
    return NO;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)dummy_tableView:(UITableView*)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.canMoveRow) {
        return self.canMoveRow(self, tableView, indexPath);
    }
    return NO;
}

// Index

// return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (nullable NSArray<NSString*>*)dummy_sectionIndexTitlesForTableView:(UITableView*)tableView {
    if (self.sectionIndexTitles) {
        return self.sectionIndexTitles(self, tableView);
    }
    return nil;
}
// tell table which section corresponds to section title/index (e.g. "B",1))
- (NSInteger)dummy_tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    if (self.sectionForSectionIndexTitle) {
        self.sectionForSectionIndexTitle(self, tableView, title, index);
    }
    return 0;
}

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead

- (void)dummy_tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.commitEditingStyle) {
        self.commitEditingStyle(self, tableView, editingStyle, indexPath);
    }
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    if (self.moveRow) {
        self.moveRow(self, tableView,sourceIndexPath, destinationIndexPath);
    }
}

#pragma mark - UITableViewDelegate-Dummy
// Display customization
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.willDisplayCell) {
        self.willDisplayCell(self, tableView, cell, indexPath);
    }
}
- (void)tableView:(UITableView*)tableView willDisplayHeaderView:(UIView*)view forSection:(NSInteger)section {
    if (self.willDisplayHeaderView) {
        self.willDisplayHeaderView(self, tableView, view, section);
    }
}
- (void)tableView:(UITableView*)tableView willDisplayFooterView:(UIView*)view forSection:(NSInteger)section {
    if (self.willDisplayFooterView) {
        self.willDisplayFooterView(self, tableView, view, section);
    }
}
- (void)tableView:(UITableView*)tableView didEndDisplayingCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.didEndDisplayingCell) {
        self.didEndDisplayingCell(self, tableView, cell, indexPath);
    }
}
- (void)tableView:(UITableView*)tableView didEndDisplayingHeaderView:(UIView*)view forSection:(NSInteger)section {
    if (self.didEndDisplayingHeaderView) {
        self.didEndDisplayingHeaderView(self, tableView, view, section);
    }
}
- (void)tableView:(UITableView*)tableView didEndDisplayingFooterView:(UIView*)view forSection:(NSInteger)section {
    if (self.didEndDisplayingFooterView) {
        self.didEndDisplayingFooterView(self, tableView, view, section);
    }
}

// Variable height support
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.heightForHeader) {
        return self.heightForHeader(self, tableView, section);
    }

    return 0;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    if (self.heightForFooter) {
        return self.heightForFooter(self, tableView, section);
    }
    return 0;
}

// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
- (CGFloat)dummy_tableView:(UITableView*)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.estimatedHeightForRow) {
        return self.estimatedHeightForRow(self, tableView, indexPath);
    }
    return 0;
}
- (CGFloat)dummy_tableView:(UITableView*)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if (self.estimatedHeightForHeader) {
        self.estimatedHeightForHeader(self, tableView, section);
    }
    return 0;
}
- (CGFloat)dummy_tableView:(UITableView*)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    if (self.estimatedHeightForFooter) {
        return self.estimatedHeightForFooter(self, tableView, section);
    }
    return 0;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

// custom view for header. will be adjusted to default or specified header height
- (nullable UIView*)dummy_tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.viewForHeader) {
        return self.viewForHeader(self, tableView, section);
    }
    return nil;
}
// custom view for footer. will be adjusted to default or specified footer height
- (nullable UIView*)dummy_tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    if (self.viewForFooter) {
        return self.viewForFooter(self, tableView, section);
    }
    return nil;
}

// Accessories (disclosures).
- (void)tableView:(UITableView*)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath {
    if (self.accessoryButtonTappedForRowWithIndexPath) {
        self.accessoryButtonTappedForRowWithIndexPath(self, tableView, indexPath);
    }
}

// Selection

// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
- (BOOL)dummy_tableView:(UITableView*)tableView shouldHighlightRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.shouldHighlightRow) {
        return self.shouldHighlightRow(self, tableView, indexPath);
    }
    return NO;
}
- (void)tableView:(UITableView*)tableView didHighlightRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.didHighlightRow) {
        self.didHighlightRow(self, tableView, indexPath);
    }
}
- (void)tableView:(UITableView*)tableView didUnhighlightRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.didUnhighlightRow) {
        self.didUnhighlightRow(self, tableView, indexPath);
    }
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (nullable NSIndexPath*)dummy_tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.willSelectRow) {
        return self.willSelectRow(self, tableView, indexPath);
    }
    return nil;
}
- (nullable NSIndexPath*)dummy_tableView:(UITableView*)tableView willDeselectRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.willDeselectRow) {
        self.willDeselectRow(self, tableView, indexPath);
    }
    return nil;
}
// Called after the user changes the selection.
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.didSelectRow) {
        self.didSelectRow(self, tableView, indexPath);
    }
}
- (void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.didDeselectRow) {
        self.didDeselectRow(self, tableView, indexPath);
    }
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)dummy_tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.editingStyleForRow) {
        return self.editingStyleForRow(self, tableView, indexPath);
    }
    return UITableViewCellEditingStyleNone;
}
- (nullable NSString*)dummy_tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.titleForDeleteConfirmationButtonForRow) {
        return self.titleForDeleteConfirmationButtonForRow(self, tableView, indexPath);
    }
    return nil;
}
// supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
- (nullable NSArray<UITableViewRowAction*>*)dummy_tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.editActionsForRow) {
        return self.editActionsForRow(self, tableView,  indexPath);
    }
    return nil;
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)dummy_tableView:(UITableView*)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.shouldIndentWhileEditingRow) {
        return self.shouldIndentWhileEditingRow(self, tableView, indexPath);
    }
    return NO;
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.willBeginEditingRow) {
        self.willBeginEditingRow(self, tableView, indexPath);
    }
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath*)indexPath {
    if (self.didEndEditingRow) {
        self.didEndEditingRow(self, tableView, indexPath);
    }
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath*)dummy_tableView:(UITableView*)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath*)sourceIndexPath toProposedIndexPath:(NSIndexPath*)proposedDestinationIndexPath {
    if (self.targetIndexPathForMoveFromRow) {
        return self.targetIndexPathForMoveFromRow(self, tableView, sourceIndexPath, proposedDestinationIndexPath);
    }
    return nil;
}

// Indentation

// return 'depth' of row for hierarchies
- (NSInteger)dummy_tableView:(UITableView*)tableView indentationLevelForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.indentationLevelForRow) {
        return self.indentationLevelForRow(self, tableView,  indexPath);
    }
    return 0;
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)dummy_tableView:(UITableView*)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.shouldShowMenuForRow) {
        return self.shouldShowMenuForRow(self, tableView, indexPath);
    }
    return NO;
}
- (BOOL)dummy_tableView:(UITableView*)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(nullable id)sender {
    if (self.canPerformAction) {
        return self.canPerformAction(self, tableView, action, indexPath, sender);
    }
    return NO;
}
- (void)tableView:(UITableView*)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(nullable id)sender {
    if (self.performAction) {
        self.performAction(self, tableView, action, indexPath, sender);
    }
}

// Focus

- (BOOL)dummy_tableView:(UITableView*)tableView canFocusRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.canFocusRow) {
        return self.canFocusRow(self, tableView, indexPath);
    }
    return NO;
}
- (BOOL)dummy_tableView:(UITableView*)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext*)context {
    if (self.shouldUpdateFocusInContext) {
        return self.shouldUpdateFocusInContext(self, tableView, context);
    }
    return NO;
}
- (void)tableView:(UITableView*)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext*)context withAnimationCoordinator:(UIFocusAnimationCoordinator*)coordinator {
    if (self.didUpdateFocusInContext) {
        self.didUpdateFocusInContext(self, tableView, context, coordinator);
    }
}
- (nullable NSIndexPath*)dummy_indexPathForPreferredFocusedViewInTableView:(UITableView*)tableView {
    if (self.indexPathForPreferredFocusedView) {
        return self.indexPathForPreferredFocusedView(self, tableView);
    }
    return nil;
}

#pragma mark - setters
#pragma mark - UITableViewDataSource

// Default is 1 if not implemented
- (void)setNumberOfSections:(NSInteger (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView))numberOfSections {
    _numberOfSections = numberOfSections;
    CONNECT_DUMMY_AND_BLOCK(numberOfSectionsInTableView:);
}

// fixed font style. use custom view (UILabel) if you want something different
- (void)setTitleForHeader:(NSString*_Nullable (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSInteger section))titleForHeaderInSection {
    _titleForHeader = titleForHeaderInSection;
    CONNECT_DUMMY_AND_BLOCK(tableView: titleForHeaderInSection:);
}

- (void)setTitleForFooter:(NSString*_Nullable (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSInteger section))titleForFooterInSection {
    _titleForFooter = titleForFooterInSection;
    CONNECT_DUMMY_AND_BLOCK(tableView: titleForFooterInSection:);
}

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (void)setCanEditRow:(BOOL (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))canEditRowAtIndexPath {
    _canEditRow = canEditRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: canEditRowAtIndexPath:);
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (void)setCanMoveRow:(BOOL (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))canMoveRowAtIndexPath {
    _canMoveRow = canMoveRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: canMoveRowAtIndexPath:);
}

// Index

// return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (void)setSectionIndexTitles:(NSArray<NSString*>*_Nullable (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView))sectionIndexTitles {
    _sectionIndexTitles = sectionIndexTitles;
    CONNECT_DUMMY_AND_BLOCK(sectionIndexTitlesForTableView:);
}
// tell table which section corresponds to section title/index (e.g. "B",1))
- (void)setSectionForSectionIndexTitle:(NSInteger (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSString*title, NSInteger index))sectionForSectionIndexTitle {
    _sectionForSectionIndexTitle = sectionForSectionIndexTitle;
    CONNECT_DUMMY_AND_BLOCK(tableView: sectionForSectionIndexTitle: atIndex:);
}

// Data manipulation - insert and delete support

#pragma mark - UITableViewDelegate
// Display customization

// Variable height support
//- (void)setHeightForHeader:(CGFloat (^)(__kindof NTYTableViewProxy *proxy, UITableView*tableView, NSInteger section))heightForHeaderInSection {
//    _heightForHeader = heightForHeaderInSection;
//    CONNECT_DUMMY_AND_BLOCK(tableView: heightForHeaderInSection:);
//}

//- (void)setHeightForFooter:(CGFloat (^)(__kindof NTYTableViewProxy *proxy, UITableView*tableView, NSInteger section))heightForFooterInSection {
//    _heightForFooter = heightForFooterInSection;
//    CONNECT_DUMMY_AND_BLOCK(tableView: heightForFooterInSection:);
//}

// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
- (void)setEstimatedHeightForRow:(CGFloat (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))estimatedHeightForRowAtIndexPath {
    _estimatedHeightForRow = estimatedHeightForRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: estimatedHeightForRowAtIndexPath:);
}

- (void)setEstimatedHeightForHeader:(CGFloat (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSInteger section))estimatedHeightForHeaderInSection {
    _estimatedHeightForHeader = estimatedHeightForHeaderInSection;
    CONNECT_DUMMY_AND_BLOCK(tableView: estimatedHeightForHeaderInSection:);
}

- (void)setEstimatedHeightForFooter:(CGFloat (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSInteger section))estimatedHeightForFooterInSection {
    _estimatedHeightForFooter = estimatedHeightForFooterInSection;
    CONNECT_DUMMY_AND_BLOCK(tableView: estimatedHeightForFooterInSection:);
}

// Section header & footer information. Views are preferred over title should you decide to provide both

// custom view for header. will be adjusted to default or specified header height
- (void)setViewForHeader:(UIView*_Nullable (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSInteger section))viewForHeaderInSection {
    _viewForHeader = viewForHeaderInSection;
    CONNECT_DUMMY_AND_BLOCK(tableView: viewForHeaderInSection:);
}
// custom view for footer. will be adjusted to default or specified footer height
- (void)setViewForFooter:(UIView*_Nullable (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSInteger section))viewForFooterInSection {
    _viewForFooter = viewForFooterInSection;
    CONNECT_DUMMY_AND_BLOCK(tableView: viewForFooterInSection:);
}

// Accessories (disclosures).
// Selection

// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
- (void)setShouldHighlightRow:(BOOL (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))shouldHighlightRowAtIndexPath {
    _shouldHighlightRow = shouldHighlightRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: shouldHighlightRowAtIndexPath:);
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (void)setWillSelectRow:(NSIndexPath*_Nullable (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))willSelectRowAtIndexPath {
    _willSelectRow = willSelectRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: willSelectRowAtIndexPath:);
}
- (void)setWillDeselectRowh:(NSIndexPath*_Nullable (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))willDeselectRowAtIndexPath {
    _willDeselectRow = willDeselectRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: willDeselectRowAtIndexPath:);
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (void)setEditingStyleForRow:(UITableViewCellEditingStyle (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))editingStyleForRowAtIndexPath {
    _editingStyleForRow = editingStyleForRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: editingStyleForRowAtIndexPath:);
}
- (void)setTitleForDeleteConfirmationButtonForRow:(NSString*_Nullable (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))titleForDeleteConfirmationButtonForRowAtIndexPath {
    _titleForDeleteConfirmationButtonForRow = titleForDeleteConfirmationButtonForRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: titleForDeleteConfirmationButtonForRowAtIndexPath:);
}
// supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
- (void)setEditActionsForRow:(NSArray<UITableViewRowAction*>*_Nullable (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))editActionsForRowAtIndexPath {
    _editActionsForRow = editActionsForRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: editActionsForRowAtIndexPath:);
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (void)setShouldIndentWhileEditingRow:(BOOL (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))shouldIndentWhileEditingRowAtIndexPath {
    _shouldIndentWhileEditingRow = shouldIndentWhileEditingRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: shouldIndentWhileEditingRowAtIndexPath:);
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (void)setTargetIndexPathForMoveFromRow:(NSIndexPath*(^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*sourceIndexPath, NSIndexPath*proposedDestinationIndexPath))targetIndexPathForMoveFromRowAtIndexPath {
    _targetIndexPathForMoveFromRow = targetIndexPathForMoveFromRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: targetIndexPathForMoveFromRowAtIndexPath: toProposedIndexPath:);
}

// Indentation

// return 'depth' of row for hierarchies
- (void)setIndentationLevelForRow:(NSInteger (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))indentationLevelForRowAtIndexPath {
    _indentationLevelForRow = indentationLevelForRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: indentationLevelForRowAtIndexPath:);
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (void)setShouldShowMenuForRow:(BOOL (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))shouldShowMenuForRowAtIndexPath {
    _shouldShowMenuForRow = shouldShowMenuForRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: shouldShowMenuForRowAtIndexPath:);
}
- (void)setCanPerformAction:(BOOL (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, SEL action, NSIndexPath*indexPath, id _Nullable sender))canPerformAction {
    _canPerformAction = canPerformAction;
    CONNECT_DUMMY_AND_BLOCK(tableView: canPerformAction: forRowAtIndexPath: withSender:);
}

// Focus
- (void)setCanFocusRow:(BOOL (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, NSIndexPath*indexPath))canFocusRowAtIndexPath {
    _canFocusRow = canFocusRowAtIndexPath;
    CONNECT_DUMMY_AND_BLOCK(tableView: canFocusRowAtIndexPath:);
}
- (void)setShouldUpdateFocusInContext:(BOOL (^)(__kindof NTYTableViewProxy*proxy, UITableView*tableView, UITableViewFocusUpdateContext*context))shouldUpdateFocusInContext {
    _shouldUpdateFocusInContext = shouldUpdateFocusInContext;
    CONNECT_DUMMY_AND_BLOCK(tableView: shouldUpdateFocusInContext:);
}

- (void)setIndexPathForPreferredFocusedView:(NSIndexPath*_Nullable (^)(__kindof NTYTableViewProxy*proxy, UITableView*_Nonnull))indexPathForPreferredFocusedView {
    _indexPathForPreferredFocusedView = indexPathForPreferredFocusedView;
    CONNECT_DUMMY_AND_BLOCK(indexPathForPreferredFocusedViewInTableView:);
}

- (void)setCommitEditingStyle:(void (^)(__kindof NTYTableViewProxy*_Nonnull, UITableView*_Nonnull, UITableViewCellEditingStyle, NSIndexPath*_Nonnull))commitEditingStyle {
    _commitEditingStyle = commitEditingStyle;
    CONNECT_DUMMY_AND_BLOCK(tableView: commitEditingStyle: forRowAtIndexPath:);
}

@end

@interface NTYSectionTableViewProxy ()
@end

@implementation NTYSectionTableViewProxy
+ (instancetype)proxy:(UITableView*)tableView {
    return [self proxy:tableView customHeaderFooterView:NO];
}

+ (instancetype)proxy:(UITableView*)tableView customHeaderFooterView:(BOOL)customHeaderFooterView {
    NTYSectionTableViewProxy*proxy = [[self alloc] initWithTableView:tableView];

    proxy.viewForHeader = ^UIView*_Nullable (NTYTableViewProxy*_Nonnull proxy, UITableView*_Nonnull tableView, NSInteger section) {
        NTYSectionTableViewProxy        *sectionProxy     = [self cast:proxy];
        id<NTYTableViewSectionViewModel> sectionViewModel = [sectionProxy viewModelForSection:section];
        id<NTYReuseViewViewModel>        headerViewModel  = nil;
        if ([(NSObject*) sectionViewModel respondsToSelector:@selector(header)]) {
            headerViewModel = sectionViewModel.header;
        }
        if (!headerViewModel) {
            return nil;
        }
        NSString                                          *reuseIdentifier = [self reuseIdentifierFromReuseViewViewModel:headerViewModel];

        NTYTableViewHeaderFooterView<NTYSupportViewModel> *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
        if ([view conformsToProtocol:@protocol(NTYSupportViewModel)]) {
            [view setViewModel:headerViewModel];
        }

        if ([view respondsToSelector:@selector(setClickComponent:)]) {
            @weakify(proxy);
            view.clickComponent = ^(NTYTableViewHeaderFooterView *view, id context) {
                @strongify(proxy);
                if (proxy.didSelectHeaderView) {
                    proxy.didSelectHeaderView(proxy, view, section, context);
                }
            };
        }
        return view;
    };

    proxy.viewForFooter = ^UIView*_Nullable (NTYTableViewProxy*_Nonnull proxy, UITableView*_Nonnull tableView, NSInteger section) {
        NTYSectionTableViewProxy        *sectionProxy     = [self cast:proxy];
        id<NTYTableViewSectionViewModel> sectionViewModel = [sectionProxy viewModelForSection:section];
        id<NTYReuseViewViewModel>        footerViewModel  = nil;
        if ([(NSObject*) sectionViewModel respondsToSelector:@selector(footer)]) {
            footerViewModel = sectionViewModel.footer;
        }
        if (!footerViewModel) {
            return nil;
        }

        NSString *reuseIdentifier = [self reuseIdentifierFromReuseViewViewModel:footerViewModel];


        NTYTableViewHeaderFooterView<NTYSupportViewModel> *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
        if ([view conformsToProtocol:@protocol(NTYSupportViewModel)]) {
            [view setViewModel:footerViewModel];
        }

        if ([view respondsToSelector:@selector(setClickComponent:)]) {
            @weakify(proxy);
            view.clickComponent = ^(NTYTableViewHeaderFooterView *view, id context) {
                @strongify(proxy);
                if (proxy.didSelectFooterView) {
                    proxy.didSelectFooterView(proxy, view, section, context);
                }
            };
        }
        return view;
    };

    return proxy;
}

#pragma mark - Update Section
- (void)updateViewModels:(__kindof NSArray<NTYTableViewSectionViewModel>*)viewModels {
    self.viewModels           = viewModels.mutableCopy;
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self.tableView reloadData];
}

- (void)appendViewModels:(NSArray<NTYTableViewSectionViewModelType>*)viewModels {
    [self appendViewModels:viewModels rowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)appendViewModels:(NSArray<NTYTableViewSectionViewModelType>*)viewModels rowAnimation:(UITableViewRowAnimation)animation {
    [self appendViewModels:viewModels updateViewModels:YES rowAnimation:animation];
}

- (void)appendViewModels:(__kindof NSArray<NTYTableViewSectionViewModelType>*)viewModels updateViewModels:(BOOL)updateViewModels rowAnimation:(UITableViewRowAnimation)animation {
    NSInteger          base     = self.viewModels.count;
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [viewModels nty_each:^(NTYTableViewSectionViewModelType item, NSUInteger index) {
        [indexSet addIndex:index + base];
    }];

    [self.tableView beginUpdates];
    if (updateViewModels) {
        [self.viewModels addObjectsFromArray:viewModels];
    }
    [self.tableView insertSections:indexSet withRowAnimation:animation];
    [self.tableView endUpdates];
}



- (void)insertViewModels:(NSArray*)viewModels atSections:(NSArray<NSNumber*>*)sections {
    [self insertViewModels:viewModels atSections:sections rowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertViewModels:(NSArray*)viewModels atSections:(NSArray<NSNumber*>*)sections rowAnimation:(UITableViewRowAnimation)animation {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [sections nty_each:^(NSNumber *item, NSUInteger index) {
        [indexSet addIndex:[item unsignedIntegerValue]];
    }];
    [self.tableView beginUpdates];
    [self.viewModels insertObjects:viewModels atIndexes:indexSet];
    [self.tableView insertSections:indexSet withRowAnimation:animation];
    [self.tableView endUpdates];
}

- (void)reloadViewModelsAtSection:(NSUInteger)section {
    [self reloadViewModelsAtSection:section rowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)reloadViewModelsAtSection:(NSUInteger)section rowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *indesSet = [NSIndexSet indexSetWithIndex:section];
    [self.tableView beginUpdates];
    [self.tableView reloadSections:indesSet withRowAnimation:animation];
    [self.tableView endUpdates];
}

- (void)appendViewModels:(NSArray*)viewModels inSection:(NSUInteger)section {
    [self appendViewModels:viewModels inSection:section rowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)appendViewModels:(NSArray*)viewModels inSection:(NSUInteger)section rowAnimation:(UITableViewRowAnimation)animation {
    NSInteger base       = self.viewModels.count;
    NSArray  *indexPaths = [viewModels nty_map:^id (id obj, NSUInteger idx) {
        return [NSIndexPath indexPathForRow:base + idx inSection:0];
    }];
    id<NTYTableViewSectionViewModel> sectionViewModel = [self viewModelForSection:section];
    NSMutableArray                  *cellViewModels   = [NSMutableArray cast:[sectionViewModel cellViewModels]];
    if (!cellViewModels) {
        NSLogError(@"无法向指定的section追加内容. section:%@", sectionViewModel);
        return;
    }

    [self.tableView beginUpdates];
    [cellViewModels addObjectsFromArray:viewModels];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self.tableView endUpdates];
}

#pragma mark - Update Rows
- (void)insertViewModels:(NSArray*)viewModels atIndexPaths:(NSArray*)indexPaths {
    [self insertViewModels:viewModels atIndexPaths:indexPaths rowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)insertViewModels:(NSArray*)viewModels atIndexPaths:(NSArray*)indexPaths rowAnimation:(UITableViewRowAnimation)animation {
    [self insertViewModels:viewModels atIndexPaths:indexPaths updateViewModels:YES rowAnimation:animation];
}
- (void)insertViewModels:(NSArray*)viewModels atIndexPaths:(NSArray*)indexPaths updateViewModels:(BOOL)updateViewModels rowAnimation:(UITableViewRowAnimation)animation {
    [self.tableView beginUpdates];

    NSArray *acceptedIndexPaths = indexPaths;
    if (updateViewModels) {
        NSMutableDictionary *sections     = [NSMutableDictionary dictionaryWithCapacity:indexPaths.count];
        NSMutableDictionary *sectionDatas = [NSMutableDictionary dictionaryWithCapacity:indexPaths.count];
        [indexPaths nty_each:^(NSIndexPath*item, NSUInteger index) {
            id key = @(item.section);
            /// 按照section分类indexPaths
            NSMutableArray *rows = [NSMutableArray cast:sections[key]];
            if (rows) {
                rows = [NSMutableArray arrayWithCapacity:0x10];
                sections[key] = rows;
            }
            [rows addObject:item];

            /// 按照section分类viewModels
            NSMutableArray *rowDatas = [NSMutableArray cast:sectionDatas[key]];
            if (rowDatas) {
                rowDatas = [NSMutableArray arrayWithCapacity:0x10];
                sectionDatas[key] = rowDatas;
            }
            [rowDatas addObject:viewModels[index]];
        }];

        /// 将section从小到大排序, 提高插入效率
        NSArray *sortedSections = [[sections allKeys] sortedArrayUsingComparator:^NSComparisonResult (id _Nonnull obj1, id _Nonnull obj2) {
            return [obj1 unsignedIntegerValue] < [obj2 unsignedIntegerValue];
        }];

        acceptedIndexPaths = [NSMutableArray arrayWithCapacity:indexPaths.count];
        [sortedSections nty_each:^(id item, NSUInteger index) {
            NSUInteger section = [item unsignedIntegerValue];
            id<NTYTableViewSectionViewModel> sectionViewModel = [self viewModelForSection:section];
            NSMutableArray                  *cellViewModels = [NSMutableArray cast:[sectionViewModel cellViewModels]];
            if (!cellViewModels) {
                NSLogError(@"无法向指定的section追加内容. section:%@", sectionViewModel);
                return;
            }
            NSArray *indexPaths = sections[item];
            NSArray *viewModels = sectionDatas[item];
            NSIndexSet *set = [[self class] indexSetFromIndexPaths:indexPaths];
            [cellViewModels insertObjects:viewModels atIndexes:set];
            [(NSMutableArray*) acceptedIndexPaths addObjectsFromArray:acceptedIndexPaths];
        }];
    }

    [self.tableView insertRowsAtIndexPaths:acceptedIndexPaths withRowAnimation:animation];
    [self.tableView endUpdates];
}

+ (id<NTYTableViewSectionViewModel>)viewModelForSection:(NSInteger)section from:(NSMutableArray<NTYTableViewSectionViewModelType>*)sectionViewModels {
    id sectionViewModel = sectionViewModels[section];
    if ([sectionViewModel conformsToProtocol:@protocol(NTYTableViewSectionViewModel)]) {
        return sectionViewModel;
    } else {
        NSLogWarn(@"%@ not conforms to %@", sectionViewModel, @protocol(NTYTableViewSectionViewModel));
    }
    return nil;
}

+ (NSMutableArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths from:(NSMutableArray<NTYTableViewSectionViewModelType>*)sectionViewModels {
    NSMutableDictionary *sections = [NSMutableDictionary dictionaryWithCapacity:indexPaths.count];
    [indexPaths nty_each:^(NSIndexPath*item, NSUInteger index) {
        id key = @(item.section);
        /// 按照section分类indexPaths
        NSMutableArray *rows = [NSMutableArray cast:sections[key]];
        if (rows) {
            rows = [NSMutableArray arrayWithCapacity:0x10];
            sections[key] = rows;
        }
        [rows addObject:item];
    }];

    /// 将section从小到大排序, 提高插入效率
    NSArray *sortedSections = [[sections allKeys] sortedArrayUsingComparator:^NSComparisonResult (id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 unsignedIntegerValue] < [obj2 unsignedIntegerValue];
    }];

    NSMutableArray *acceptedIndexPaths = [NSMutableArray arrayWithCapacity:indexPaths.count];
    [sortedSections nty_each:^(id item, NSUInteger index) {
        NSUInteger section = [item unsignedIntegerValue];
        id<NTYTableViewSectionViewModel> sectionViewModel = [[self class] viewModelForSection:section from:sectionViewModels];
        NSMutableArray                  *cellViewModels = [NSMutableArray cast:[sectionViewModel cellViewModels]];
        if (!cellViewModels) {
            NSLogError(@"无法从指定的section删除内容. section:%@", sectionViewModel);
            return;
        }
        NSArray *indexPaths = sections[item];
        NSIndexSet *set = [[self class] indexSetFromIndexPaths:indexPaths];
        [cellViewModels removeObjectsAtIndexes:set];
        [acceptedIndexPaths addObjectsFromArray:acceptedIndexPaths];
    }];

    return acceptedIndexPaths;
}

- (NSArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths {
    return [self removeViewModelsAtIndexPaths:indexPaths rowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths rowAnimation:(UITableViewRowAnimation)animation {
    return [self removeViewModelsAtIndexPaths:indexPaths updateViewModels:YES rowAnimation:animation];
}

- (NSArray<NSIndexPath*>*)removeViewModelsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths updateViewModels:(BOOL)updateViewModels rowAnimation:(UITableViewRowAnimation)animation {
    [self.tableView beginUpdates];

    NSArray<NSIndexPath*> *removedIndexPaths = indexPaths;
    if (updateViewModels) {
        removedIndexPaths = [[self class] removeViewModelsAtIndexPaths:indexPaths from:self.viewModels];
    }
    [self.tableView deleteRowsAtIndexPaths:removedIndexPaths withRowAnimation:animation];
    [self.tableView endUpdates];

    return removedIndexPaths;
}

#pragma mark - Query
- (id<NTYTableViewSectionViewModel>)viewModelForSection:(NSInteger)section {
    return [[self class] viewModelForSection:section from:self.viewModels];
}

- (id<NTYTableViewHeaderFooterViewViewModel>)headerViewModelForSection:(NSInteger)section {
    return [self viewModelForSection:section].header;
}
- (id<NTYTableViewHeaderFooterViewViewModel>)footerViewModelForSection:(NSInteger)section {
    return [self viewModelForSection:section].header;
}
- (NSArray<NTYTableViewCellViewModelType>*)cellViewModelsForSection:(NSInteger)section {
    id<NTYTableViewSectionViewModel> viewModel = [self viewModelForSection:section];
    return [viewModel cellViewModels];
}

- (NTYTableViewCellViewModelType)viewModelForRow:(NSIndexPath*)indexPath {
    return [self cellViewModelsForSection:indexPath.section][indexPath.row];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return self.viewModels.count;
}

#pragma mark -
// Variable height support
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    id<NTYTableViewSectionViewModel> viewModel = [self viewModelForSection:section];
    if (!viewModel.header) {
        return 0;
    }

    if (self.heightForHeader) {
        return self.heightForHeader(self, tableView, section);
    }
    id <NTYTableViewHeaderFooterViewViewModel> headerViewModel = viewModel.header;
    if ([headerViewModel respondsToSelector:@selector(viewHeight)]) {
        CGFloat viewHeight = [headerViewModel viewHeight];
        if (fabs(viewHeight) > 0.000001) {
            return viewHeight;
        }
    }
    NSString *reuseIdentifier = [[self class] reuseIdentifierFromReuseViewViewModel:headerViewModel];
    CGFloat   height          = [tableView fd_heightForHeaderFooterViewWithIdentifier:reuseIdentifier configuration:^(id view) {
        if ([view respondsToSelector:@selector(setViewModel:)]) {
            [view setViewModel:viewModel];
        }
    }];

    return height;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    id<NTYTableViewSectionViewModel> viewModel = [self viewModelForSection:section];
    if (!viewModel.footer) {
        return 0;
    }

    if (self.heightForFooter) {
        return self.heightForFooter(self, tableView, section);
    }

    id <NTYTableViewHeaderFooterViewViewModel> footerViewModel = viewModel.footer;
    if ([footerViewModel respondsToSelector:@selector(viewHeight)]) {
        CGFloat viewHeight = [footerViewModel viewHeight];
        if (fabs(viewHeight) > 0.000001) {
            return viewHeight;
        }
    }

    NSString *reuseIdentifier = [[self class] reuseIdentifierFromReuseViewViewModel:footerViewModel];
    CGFloat   height          = [tableView fd_heightForHeaderFooterViewWithIdentifier:reuseIdentifier configuration:^(id view) {
        if ([view respondsToSelector:@selector(setViewModel:)]) {
            [view setViewModel:viewModel];
        }
    }];

    return height;
}
@end
