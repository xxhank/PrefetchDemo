//
//  NTYTableViewHeaderFooterView.h
//  SARRS
//
//  Created by xuewu.long on 17/7/11.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, TableViewSectionDecorate) {
    TableViewSectionDecorateHeader,
    TableViewSectionDecorateFooter
};

@interface NTYTableViewHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic,copy) void (^clickComponent)(NTYTableViewHeaderFooterView *view, id context);
@end

@interface NTYInteractableTableViewHeaderFooterView : NTYTableViewHeaderFooterView

#pragma mark - support subclassing
- (void)handleSelectEvent:(id)sender;
@end

extern NSString* const NTYTableViewHeaderFooterViewSelectEvent;
