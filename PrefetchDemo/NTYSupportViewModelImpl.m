//
//  NTYSupportViewModelImpl.m
//  SARRS
//
//  Created by wangchao on 2017/7/15.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import "NTYSupportViewModelImpl.h"

@interface NTYReuseViewViewModelImpl ()
@property (nonatomic, strong) NSString *reuseIdentifier;
@end

@implementation NTYReuseViewViewModelImpl
+ (instancetype)viewModel:(NSString*)reuseIdentifier {
    NTYReuseViewViewModelImpl*impl = [self new];
    impl.reuseIdentifier = reuseIdentifier;
    return impl;
}

@end
