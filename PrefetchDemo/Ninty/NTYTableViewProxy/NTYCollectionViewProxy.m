//
//  NTYCollectionViewProxy.m
//  SARRS
//
//  Created by wangchao on 2017/7/4.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import "NTYCollectionViewProxy.h"

@implementation NTYCollectionViewProxy
#pragma mark - help
+ (NSString*)reuseIdentifierFromCellViewModel:(id<NTYCollectionViewCellViewModel>)viewModel {
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
        className        = [className stringByReplacingOccurrencesOfString:@"ViewModelImpl" withString:@""];
        className        = [className stringByReplacingOccurrencesOfString:@"ViewModel" withString:@""];
        reuseIdentifier = className;
    }

    return reuseIdentifier;
}
@end
