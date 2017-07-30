//
//  NTYCollectionViewProxy.h
//  SARRS
//
//  Created by wangchao on 2017/7/4.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import "NTYScrollViewProxy.h"
#import "NTYSupportViewModel.h"

@interface NTYCollectionViewProxy : NTYScrollViewProxy
+ (NSString*)reuseIdentifierFromCellViewModel:(id<NTYCollectionViewCellViewModel>)viewModel;
+ (NSString*)reuseIdentifierFromReuseViewViewModel:(id<NTYReuseViewViewModel>)viewModel;
@end
