//
//  NTYTableViewCell.m
//  SARRS
//
//  Created by wangchao on 2017/7/4.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import "NTYTableViewCell.h"
#import "NTYCollectionViewProxy.h"

@implementation NTYTableViewCell
- (void)setViewModel:(id)viewModel {
}
@end


@interface NTYMultiItemTableViewCell ()<UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout>

@end

@implementation NTYMultiItemTableViewCell
- (void)setViewModel:(NTYMultiItemTableViewCellViewModelType)viewModel {
    _viewModel = viewModel;

    self.heightConstraint.constant = [self calculateSizeThatFits:SCREEN_BOUNDS.size forItem:NO].height;

    if (!self.fd_isTemplateLayoutCell) {
        self.collectionView.dataSource = self;
        self.collectionView.delegate   = self;
        [self.collectionView reloadData];
    }

    [self viewModelDidSet];
}

#pragma mark - support subclassing
- (CGSize)calculateSizeThatFits:(CGSize)size forItem:(BOOL)forItem {
    return SIZE(40, 40);
}
- (void)viewModelDidSet {
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.itemViewModels.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    NTYCollectionViewCellViewModelType cellViewModel = self.viewModel.itemViewModels[indexPath.row];


    NSString *reuseIdentifier = nil;
    if ([cellViewModel respondsToSelector:@selector(reuseIdentifier)]) {
        reuseIdentifier = [cellViewModel reuseIdentifier];
    } else {
        reuseIdentifier = [NTYCollectionViewProxy reuseIdentifierFromCellViewModel:cellViewModel];
    }
    NTYRAssertNotNil(reuseIdentifier, [UICollectionViewCell new]);
    reuseIdentifier = reuseIdentifier?:@"null-reuse-identifier";

    UICollectionViewCell<NTYSupportViewModel> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(NTYSupportViewModel)]) {
        [cell setViewModel:cellViewModel];
    }
    return cell?:[[UICollectionViewCell alloc] init];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    CGSize size = [self calculateSizeThatFits:collectionView.bounds.size forItem:YES];
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.sectionInsets;
}
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpacing;
}
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.itemSpacing;
}
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return SIZE(0, 0);
}
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return SIZE(0, 0);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath;
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%@",indexPath);
    if (self.clickComponent) {
        self.clickComponent(self, indexPath);
    }
}

@end
