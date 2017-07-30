//
//  NSObject+Decorate.m
//  SARRS
//
//  Created by wangchao on 2017/6/25.
//  Copyright © 2017年 wangchao9. All rights reserved.
//

#import "NSObject+Decorate.h"

@implementation NSObject (NTYDecorate)
- (instancetype)sas_decorate:(NTYDecorateBlock)block {
    if (block) {
        block(self);
    }
    return self;
}
@end

#ifdef DEBUG

#endif // ifdef DEBUG
