//
//  NTYTableViewCell.h
//  SARRS
//
//  Created by wangchao on 2017/7/4.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import "NTYSupportViewModel.h"

@interface NTYTableViewCell : UITableViewCell<NTYSupportViewModel>
@property (nonatomic,copy) void (^clickComponent)(UITableViewCell*cell, id context);
@end



@interface NTYMultiItemTableViewCell : NTYTableViewCell<NTYSupportViewModel>
@property (nonatomic, strong) NTYMultiItemTableViewCellViewModelType viewModel;

#pragma mark - support subclassing
@property (weak, nonatomic) IBOutlet UICollectionView   *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (nonatomic, assign) CGFloat                    lineSpacing;
@property (nonatomic, assign) CGFloat                    itemSpacing;
@property (nonatomic, assign) UIEdgeInsets               sectionInsets;
- (CGSize)calculateSizeThatFits:(CGSize)size forItem:(BOOL)forItem;
- (void)viewModelDidSet;
@end
