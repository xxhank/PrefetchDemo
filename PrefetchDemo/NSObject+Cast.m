//
//  NSObject+Cast.m
//  SafePrograming
//
//  Created by wangchao9 on 2017/4/26.
//  Copyright © 2017年 wangchao9. All rights reserved.
//

#import "NSObject+Cast.h"

@implementation NSObject (Cast)
+ (instancetype)cast:(id)object {
    if (!object) {
        return nil;
    }

    if ([object isKindOfClass:self]) {
        return object;
    } else {
        NSLogWarn(@"类型转换失败. 无法将%@转换为%@", NSStringFromClass([object class]), NSStringFromClass(self));
    }

    return nil;
}

+ (BOOL)has:(id)object {
    if (!object) {
        return NO;
    }
    return [object isKindOfClass:self];
}
@end
