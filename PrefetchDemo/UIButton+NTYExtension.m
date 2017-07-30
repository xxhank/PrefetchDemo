//
//  UIButton+NTYExtension.m
//  SARRS
//
//  Created by wangchao on 2017/7/16.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import "UIButton+NTYExtension.h"
#import <objc/runtime.h>

@implementation UIButton (NTYExtension_Factory)
+ (instancetype)customButton {
    return [UIButton buttonWithType:UIButtonTypeCustom];
}

+ (instancetype)buttonFrame:(CGRect)frame imgSelected:(NSString*)imgSelected imgNormal:(NSString*)imgNormal imgHighlight:(NSString*)imgHighlight target:(id)target action:(SEL)action mode:(UIViewContentMode)mode ContentEdgeInsets:(UIEdgeInsets)insets {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imgSelected) {
        [btn setImage:[UIImage imageNamed:imgSelected] forState:UIControlStateSelected];
    }

    if (imgNormal) {
        [btn setImage:[UIImage imageNamed:imgNormal] forState:UIControlStateNormal];
    }

    if (imgHighlight) {
        [btn setImage:[UIImage imageNamed:imgHighlight] forState:UIControlStateHighlighted];
    }

    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:frame];
    [btn setContentEdgeInsets:insets];
    [btn.imageView setContentMode:mode];

    return btn;
}
@end

@implementation UIButton (NTYExtension_Convenience)
#pragma mark - event
- (void)addTarget:(id)target forClickAction:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - content
+ (UIImage*)imageFromImageValue:(id)image {
    if (!image) {
        return nil;
    }

    UIImage*imageResult = nil;
    if ([NSString has:image]) {
        if ([image hasPrefix:@"/"]) {
            imageResult = [UIImage imageWithContentsOfFile:image];
        } else {
            imageResult = [UIImage imageNamed:image];
        }
    } else if ([UIImage has:image]) {
        imageResult = image;
    } else {
        NSLogWarn(@"unsupport image, %@", image);
    }
    return imageResult;
}

- (void)setImageForNormal:(id)normalImageValue selected:(id)selectedImageValue hlighted:(id)hlightedImageValue disabled:(id)disabledImageValue {
    UIImage *hlighted = [[self class] imageFromImageValue:hlightedImageValue];
    if (hlighted) {
        [self setImage:hlighted forState:UIControlStateHighlighted];
    }

    UIImage *seleted = [[self class] imageFromImageValue:selectedImageValue];
    if (seleted) {
        [self setImage:seleted forState:UIControlStateSelected];
    }

    UIImage *disabled = [[self class] imageFromImageValue:disabledImageValue];
    if (disabled) {
        [self setImage:disabled forState:UIControlStateDisabled];
    }

    UIImage *normal = [[self class] imageFromImageValue:normalImageValue];
    if (normal) {
        [self setImage:normal forState:UIControlStateNormal];
    }
}

- (void)setTitleColorForNormal:(UIColor*)normal selected:(UIColor*)selected hlighted:(UIColor*)hlighted disabled:(UIColor*)disabled {
    if (hlighted) {
        [self setTitleColor:hlighted forState:UIControlStateHighlighted];
    }

    if (selected) {
        [self setTitleColor:selected forState:UIControlStateSelected];
    }

    if (disabled) {
        [self setTitleColor:disabled forState:UIControlStateDisabled];
    }

    if (normal) {
        [self setTitleColor:normal forState:UIControlStateNormal];
    }
}

- (void)setTitles:(nullable id)title {
    [self setTitlesForNormal:title selected:title hlighted:title disabled:title];
}

- (void)setTitleValue:(id)value forState:(UIControlState)state {
    if ([NSString has:value]) {
        [self setTitle:value forState:state];
    } else if ([NSAttributedString has:value]) {
        [self setAttributedTitle:normal forState:state];
    } else {
        [self setTitle:STRING(@"%@", value) forState:state];
    }
}

- (void)setTitlesForNormal:(id)normal selected:(id)selected hlighted:(id)hlighted disabled:(id)disabled {
    if (hlighted) {
        [self setTitleValue:hlighted forState:UIControlStateHighlighted];
    }

    if (selected) {
        [self setTitleValue:selected forState:UIControlStateSelected];
    }

    if (disabled) {
        [self setTitleValue:disabled forState:UIControlStateDisabled];
    }

    if (normal) {
        [self setTitleValue:normal forState:UIControlStateNormal];
    }
}

@end

@interface UIButton (NTYExtension_Layout_Private)
@property (nonatomic, strong) NSNumber *nty_spacingBetweenImageAndTitle;
@end

@implementation UIButton (NTYExtension_Layout)
NTY_ASSOCIATE_OBJECT(nty_spacingBetweenImageAndTitle, setNty_spacingBetweenImageAndTitle, RETAIN, NSNumber*);

- (void)nty_makeImageOnRight {
    UIButton *button = self;
    [button.titleLabel sizeToFit];

    CGRect titleFrame = button.titleLabel.frame;
    CGRect imageFrame = button.imageView.frame;

    if (nil == self.nty_spacingBetweenImageAndTitle) {
        self.nty_spacingBetweenImageAndTitle = @(RECT_LEFT(titleFrame) - RECT_RIGHT(imageFrame));
    }

    // title和image之间的间隙
    CGFloat      space         = [self.nty_spacingBetweenImageAndTitle floatValue];
    UIEdgeInsets contentInsets = button.contentEdgeInsets;
    CGFloat      imageOffset   = RECT_WIDTH(titleFrame) + space + contentInsets.right;
    button.imageEdgeInsets = INSETS(0, imageOffset, 0, -imageOffset);

    CGFloat titleOffset = RECT_WIDTH(imageFrame) + space + contentInsets.left;
    button.titleEdgeInsets = INSETS(0, -titleOffset, 0, titleOffset);
}

@end

@implementation UIButton (BAKit)

- (void)setupButtonLayout {
    CGFloat imageWidth  = self.imageView.bounds.size.width;
    CGFloat imageHeight = self.imageView.bounds.size.height;

    CGFloat titleWidth  = self.titleLabel.bounds.size.width;
    CGFloat titleHeight = self.titleLabel.bounds.size.height;

    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        titleWidth  = self.titleLabel.intrinsicContentSize.width;
        titleHeight = self.titleLabel.intrinsicContentSize.height;
    }

    UIEdgeInsets imageEdge = UIEdgeInsetsZero;
    UIEdgeInsets titleEdge = UIEdgeInsetsZero;

    UIEdgeInsets insets    = self.contentEdgeInsets;
    CGFloat      insetLeft = insets.left;
    // CGFloat      insetRight = insets.right;

    CGFloat ba_padding       = insetLeft;
    CGFloat ba_padding_inset = 0;

    switch (self.ba_buttonLayoutType) {
    case BAKit_ButtonLayoutTypeNormal: {
        titleEdge = UIEdgeInsetsMake(0, ba_padding, 0, 0);
        imageEdge = UIEdgeInsetsMake(0, 0, 0, ba_padding);
    }
    break;
    case BAKit_ButtonLayoutTypeCenterImageRight: {
        titleEdge = UIEdgeInsetsMake(0, -imageWidth - ba_padding, 0, imageWidth);
        imageEdge = UIEdgeInsetsMake(0, titleWidth + ba_padding, 0, -titleWidth);
    }
    break;
    case BAKit_ButtonLayoutTypeCenterImageTop: {
        titleEdge = UIEdgeInsetsMake(0, -imageWidth, -imageHeight - ba_padding, 0);
        imageEdge = UIEdgeInsetsMake(-titleHeight - ba_padding, 0, 0, -titleWidth);
    }
    break;
    case BAKit_ButtonLayoutTypeCenterImageBottom: {
        titleEdge = UIEdgeInsetsMake(-imageHeight - ba_padding, -imageWidth, 0, 0);
        imageEdge = UIEdgeInsetsMake(0, 0, -titleHeight - ba_padding, -titleWidth);
    }
    break;
    case BAKit_ButtonLayoutTypeLeftImageLeft: {
        titleEdge = UIEdgeInsetsMake(0, ba_padding + ba_padding_inset, 0, 0);

        imageEdge = UIEdgeInsetsMake(0, ba_padding_inset, 0, 0);

        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    break;
    case BAKit_ButtonLayoutTypeLeftImageRight: {
        titleEdge                       = UIEdgeInsetsMake(0, -imageWidth + ba_padding_inset, 0, 0);
        imageEdge                       = UIEdgeInsetsMake(0, titleWidth + ba_padding + ba_padding_inset, 0, 0);
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    break;
    case BAKit_ButtonLayoutTypeRightImageLeft: {
        imageEdge = UIEdgeInsetsMake(0, 0, 0, ba_padding + ba_padding_inset);
        titleEdge = UIEdgeInsetsMake(0, 0, 0, ba_padding_inset);

        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    break;
    case BAKit_ButtonLayoutTypeRightImageRight: {
        titleEdge                       = UIEdgeInsetsMake(0, 0, 0, imageWidth + ba_padding + ba_padding_inset);
        imageEdge                       = UIEdgeInsetsMake(0, 0, 0, -titleWidth + ba_padding_inset);
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    break;

    default:
        break;
    } // switch
    self.imageEdgeInsets = imageEdge;
    self.titleEdgeInsets = titleEdge;
}

#pragma mark - setter / getter
- (void)setBa_buttonLayoutType:(BAKit_ButtonLayoutType)ba_buttonLayoutType {
    objc_setAssociatedObject(self, @selector(ba_buttonLayoutType), @(ba_buttonLayoutType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupButtonLayout];
}

- (BAKit_ButtonLayoutType)ba_buttonLayoutType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//    [self setupButtonLayout];
//}

@end
