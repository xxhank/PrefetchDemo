//
//  Dispatch.m
//  SafePrograming
//
//  Created by wangchao9 on 2017/4/26.
//  Copyright © 2017年 wangchao9. All rights reserved.
//

#import "Dispatch.h"

@implementation Dispatch
+ (void)ui:(void (^)())block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            block();
        });
    }
}

+ (void)async:(dispatch_block_t)block {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        block();
    });
}

+ (void)async:(long)priority execute:(dispatch_block_t)block {
    dispatch_queue_t queue = dispatch_get_global_queue(priority,0);
    dispatch_async(queue, ^{
        block();
    });
}

+ (void)after:(NSTimeInterval)delay execute:(dispatch_block_t)block {
    int64_t          delta = (int64_t)(0.3 * NSEC_PER_SEC);
    dispatch_time_t  when  = dispatch_time(DISPATCH_TIME_NOW, delta);
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after(when,queue,block);
}

+ (void)after:(NSTimeInterval)delay priority:(long)priority execute:(dispatch_block_t)block {
    int64_t          delta = (int64_t)(0.3 * NSEC_PER_SEC);
    dispatch_time_t  when  = dispatch_time(DISPATCH_TIME_NOW, delta);
    dispatch_queue_t queue = dispatch_get_global_queue(priority,0);
    dispatch_after(when,queue,block);
}

@end

