//
// UIButton+NTYExtension.h
//  SARRS
//
//  Created by wangchao on 2017/7/16.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIButton (NTYExtension_Factory)
+ (nonnull instancetype)customButton;

+ (nonnull instancetype)buttonFrame:(CGRect)frame imgSelected:(nullable NSString*)imgSelected imgNormal:(nullable NSString*)imgNormal imgHighlight:(nullable NSString*)imgHighlight target:(nullable id)target action:(nullable SEL)action mode:(UIViewContentMode)mode ContentEdgeInsets:(UIEdgeInsets)insets;

@end

@interface UIButton (NTYExtension_Convenience)
#pragma mark - event
- (void)addTarget:(nullable id)target forClickAction:(nonnull SEL)action;

#pragma mark - content

/**
 *  一次性设置不同状态的图片
 *
 *  @param normalImageValue   普通状态的图片, 可以是UIImage, ImageName, ImagePath
 *  @param selectedImageValue 选择状态的图片, 可以是UIImage, ImageName, ImagePath
 *  @param hlightedImageValue 高亮状态的图片, 可以是UIImage, ImageName, ImagePath
 *  @param disabledImageValue 禁用状态的图片, 可以是UIImage, ImageName, ImagePath
 */
- (void)setImageForNormal:(nullable id)normalImageValue
                 selected:(nullable id)selectedImageValue
                 hlighted:(nullable id)hlightedImageValue
                 disabled:(nullable id)disabledImageValue;

- (void)setTitleColorForNormal:(nullable UIColor*)normal selected:(nullable UIColor*)selected hlighted:(nullable UIColor*)hlighted disabled:(nullable UIColor*)disabled;

- (void)setTitles:(nullable id)title;
- (void)setTitlesForNormal:(nullable id)normal
                  selected:(nullable id)selected
                  hlighted:(nullable id)hlighted
                  disabled:(nullable id)disabled;
@end




@interface UIButton (NTYExtension_Layout)
- (void)nty_makeImageOnRight;
@end

/**
   button 的样式，以图片为基准

   - BAKit_ButtonLayoutTypeNormal: button 默认样式：内容居中-图左文右
   - BAKit_ButtonLayoutTypeCenterImageRight: 内容居中-图右文左
   - BAKit_ButtonLayoutTypeCenterImageTop: 内容居中-图上文下
   - BAKit_ButtonLayoutTypeCenterImageBottom: 内容居中-图下文上
   - BAKit_ButtonLayoutTypeLeftImageLeft: 内容居左-图左文右
   - BAKit_ButtonLayoutTypeLeftImageRight: 内容居左-图右文左
   - BAKit_ButtonLayoutTypeRightImageLeft: 内容居右-图左文右
   - BAKit_ButtonLayoutTypeRightImageRight: 内容居右-图右文左
 */
typedef NS_ENUM (NSInteger, BAKit_ButtonLayoutType) {
    BAKit_ButtonLayoutTypeNormal = 0,
    BAKit_ButtonLayoutTypeCenterImageRight,
    BAKit_ButtonLayoutTypeCenterImageTop,
    BAKit_ButtonLayoutTypeCenterImageBottom,
    BAKit_ButtonLayoutTypeLeftImageLeft,
    BAKit_ButtonLayoutTypeLeftImageRight,
    BAKit_ButtonLayoutTypeRightImageLeft,
    BAKit_ButtonLayoutTypeRightImageRight,
};

@interface UIButton (BAKit)
@property (nonatomic, assign) BAKit_ButtonLayoutType ba_buttonLayoutType;
@end
NS_ASSUME_NONNULL_END
