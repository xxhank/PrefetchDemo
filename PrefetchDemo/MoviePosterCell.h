//
//  MoviePosterCell.h
//  PrefetchDemo
//
//  Created by wangchao9 on 2017/7/29.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTYTableViewCell.h"

@protocol MoviePosterCellViewModel <NTYTableViewCellViewModel>
@property (nonatomic, readonly) NSString *poster;
@end
typedef id<MoviePosterCellViewModel>          MoviePosterCellViewModelType;
typedef NSArray<MoviePosterCellViewModelType> MoviePosterCellViewModelArray;

@interface MoviePosterCell : NTYTableViewCell<NTYSupportViewModel>
@property (nonatomic, weak) IBOutlet UIImageView *posterView;
@end
