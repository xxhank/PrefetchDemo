//
//  NTYSupportViewModel.h
//  SARRS
//
//  Created by wangchao on 2017/6/30.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma once
#pragma mark - Support View Model
@protocol NTYSupportViewModel <NSObject>
- (void)setViewModel:(id)viewModel;
@end
typedef id<NTYSupportViewModel> NTYSupportViewModelType;

#pragma mark - View
@protocol NTYViewModel <NSObject>
@optional
@property (nonatomic, readonly) id model;
@end

@protocol NTYReuseViewViewModel <NTYViewModel>
@optional
@property (nonatomic, readonly) NSString *reuseIdentifier;
@end

#pragma mark - UICollectionView
@protocol NTYCollectionViewCellViewModel <NTYReuseViewViewModel>
@end
typedef id<NTYCollectionViewCellViewModel>          NTYCollectionViewCellViewModelType;
typedef NSArray<NTYCollectionViewCellViewModelType> NTYCollectionViewCellViewModelArray;

#pragma mark - UITableView
#pragma mark Header&Footer
@protocol NTYTableViewHeaderFooterViewViewModel <NTYReuseViewViewModel>
@optional
@property (nonatomic, readonly) CGFloat viewHeight;
@end

typedef id<NTYTableViewHeaderFooterViewViewModel> NTYTableViewHeaderFooterViewViewModelType;

#pragma mark Cell
@protocol NTYTableViewCellViewModel <NTYReuseViewViewModel>
@optional
@property (nonatomic, readonly) CGFloat cellHeight;
@end
typedef id<NTYTableViewCellViewModel>          NTYTableViewCellViewModelType;
typedef NSArray<NTYTableViewCellViewModelType> NTYTableViewCellViewModelTypeArray;

#pragma mark section
@protocol NTYTableViewSectionViewModel
@optional
@property (nonatomic, readonly) id<NTYTableViewHeaderFooterViewViewModel> header;
@property (nonatomic, readonly) id<NTYTableViewHeaderFooterViewViewModel> footer;

@required
@property (nonatomic, readonly) NTYTableViewCellViewModelTypeArray *cellViewModels;
@end

typedef id<NTYTableViewSectionViewModel>          NTYTableViewSectionViewModelType;
typedef NSArray<NTYTableViewSectionViewModelType> NTYTableViewSectionViewModelTypeArray;

#pragma mark MultiItem Cell
@protocol NTYMultiItemTableViewCellViewModel <NTYTableViewCellViewModel>
@property (nonatomic, readonly) NTYCollectionViewCellViewModelArray *itemViewModels;
@end

typedef id<NTYMultiItemTableViewCellViewModel> NTYMultiItemTableViewCellViewModelType;
