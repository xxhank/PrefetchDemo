//
//  NTYSupportViewModelImpl.h
//  SARRS
//
//  Created by wangchao on 2017/7/15.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTYSupportViewModel.h"

@interface NTYReuseViewViewModelImpl : NSObject<NTYReuseViewViewModel>
+ (instancetype)viewModel:(NSString*)reuseIdentifier;
@end
