//
//  NSArray+NTYExtension.m
//  SARRS
//
//  Created by wangchao9 on 2017/6/27.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import "NSArray+NTYExtension.h"

@implementation NSArray (Operations)
- (NSMutableArray*)nty_map:(id (^)(id item, NSUInteger index))block {
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL*_Nonnull stop) {
        id mapped = block(obj, idx);
        if (mapped) {
            [array addObject:mapped];
        } else {
            // NTYAssert(mapped, @"Cannot return nil for %@ %@", obj, @(idx));
        }
    }];

    return array;
}

- (NSMutableArray*)nty_filter:(BOOL (^)(id item, NSUInteger index))block {
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL*_Nonnull stop) {
        BOOL passed = block(obj, idx);
        if (passed) {
            [array addObject:obj];
        }
    }];

    return array;
}

- (NSString*)nty_joinedString:(NSString*)seperator {
    return [self componentsJoinedByString:seperator];
}

- (void)nty_each:(void (^)(id item, NSUInteger index))block {
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL*_Nonnull stop) {
        block(obj,idx);
    }];
}

- (void)nty_foreach:(void (^)(id item, NSUInteger index, BOOL*stop))block {
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL*_Nonnull stop) {
        block(obj,idx, stop);
    }];
}

- (void)nty_each:(NSArray<NSNumber*>*)indexes executor:(void (^)(id item, NSUInteger index))block {
    [indexes enumerateObjectsUsingBlock:^(NSNumber*_Nonnull obj, NSUInteger idx, BOOL *stop) {
        NSUInteger index = [obj unsignedIntegerValue];
        if (index < self.count) {
            block(self[index], index);
        }
    }];
}

- (id)nty_reduce:(id)begin executor:(id (^)(id item, NSUInteger index, id prev))block {
    __block id prev = begin;
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL*_Nonnull stop) {
        prev = block(obj,idx, prev);
    }];

    return prev;
}

- (NSMutableArray*)nty_joined:(NSArray*)array {
    if ([self isKindOfClass:[NSMutableArray
                             class]]) {
        [(NSMutableArray*) self addObjectsFromArray:array];
        return (NSMutableArray*)self;
    } else {
        NSMutableArray *result = self.mutableCopy;
        [result addObjectsFromArray:array];
        return result;
    }
}

- (id)nty_firstObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL*stop))predicate {
    NSUInteger index = [self indexOfObjectPassingTest:predicate];
    if (index == NSNotFound) {
        return nil;
    }
    return self[index];
}
@end

@implementation NSArrayOperations
+ (NSMutableArray*)map:(NSArray*)input with:(id (^)(id item, NSUInteger index))block {
    return [input nty_map:block];
}
@end
