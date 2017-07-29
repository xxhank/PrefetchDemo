//
//  MoviePosterCell.m
//  PrefetchDemo
//
//  Created by wangchao9 on 2017/7/29.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import "MoviePosterCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MoviePosterCell

- (void)setViewModel:(id<MoviePosterCellViewModel>)viewModel {
    if (!self.fd_isTemplateLayoutCell) {
        NSString *urlString   = viewModel.poster;
        UIImage  *placeholder = [UIImage imageNamed:@"default_focus"];

        [self.posterView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholder completed:^(UIImage*_Nullable image, NSError*_Nullable error, SDImageCacheType cacheType, NSURL*_Nullable imageURL) {
            if (error) {
                NSLogError(@"%@", error);
            }
        }];
    }
}
@end
