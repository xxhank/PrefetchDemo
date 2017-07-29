//
//  DataProvider.h
//  PrefetchDemo
//
//  Created by wangchao9 on 2017/7/29.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject
@property (nonatomic, readonly) NSArray<NSString*> *urls;
+ (instancetype)shared;
- (void)loadData:(NSUInteger)pageIndex completion:(void (^)(NSArray<NSString*>*urls))completion;
- (BOOL)hasMoreData:(NSUInteger)pageIndex;
@end
