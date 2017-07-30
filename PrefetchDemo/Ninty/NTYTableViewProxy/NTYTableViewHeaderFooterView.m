//
//  NTYTableViewHeaderFooterView.m
//  SARRS
//
//  Created by xuewu.long on 17/7/11.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import "NTYTableViewHeaderFooterView.h"

@implementation NTYTableViewHeaderFooterView


@end

NSString* const NTYTableViewHeaderFooterViewSelectEvent = @"header-footer-select-event";
@implementation NTYInteractableTableViewHeaderFooterView

- (void)awakeFromNib {
    [super awakeFromNib];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelectEvent:)];

    [self addGestureRecognizer:recognizer];
}

- (void)handleSelectEvent:(UIGestureRecognizer*)sender {
    if (self.clickComponent) {
        self.clickComponent(self, NTYTableViewHeaderFooterViewSelectEvent);
    }
}
@end
