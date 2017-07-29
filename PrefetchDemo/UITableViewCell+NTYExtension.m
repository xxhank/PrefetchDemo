//
//  UITableViewCell+NTYExtension.m
//  SARRS
//
//  Created by wangchao9 on 2017/7/17.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import "UITableViewCell+NTYExtension.h"

@implementation UITableViewCell (NTYExtension)
+ (instancetype)defaultStyleCell:(NSString*)reuseIdentifier {
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}
@end
