//
//  GFToast.h
//
//  Created by Mercy on 15/9/21.
//  Copyright (c) 2015年 Mercy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  外观类型
 */
typedef NS_ENUM(NSUInteger, GFToastStyle) {
    /** 浅色 */
    GFToastStyleLight,
    /** 深色 */
    GFToastStyleDark
};

/**
 *  动画类型
 */
typedef NS_ENUM(NSUInteger, GFToastAnimation){
    /** 渐隐渐现 */
    GFToastAnimationFadeInFadeOut,
    /** 缩放出现消失 */
    GFToastAnimationZoomInZoomOut // 待实现.....
};

/**
 *  持续时长
 */
typedef NS_ENUM(NSUInteger, GFToastShowTime){
    /** 短 */
    GFToastShowTimeShort,
    /** 长 */
    GFToastShowTimeLong
};

/**
 *  显示的位置
 */
typedef NS_ENUM(NSUInteger, GFToastShowPosition){
    /** 中间 */
    GFToastShowPositionCenter,
    /** 底部 */
    GFToastShowPositionBottom,
};


@interface GFToast : UIView

/**
 *  只有文本没有图片的 Toast，默认显示在底部，持续时间短，渐隐渐现
 *
 *  @param view  显示Toast的View
 *  @param text  Toast文本
 *  @param style 外观类型
 */
+ (void)showToastInView:(UIView *)view
               withText:(NSString *)text
                  style:(GFToastStyle)style;

/**
 *  既有文本又有图片的 Toast，默认显示在底部，持续时间短，渐隐渐现
 *  如果 Toast 带有图片，则文字不要超过一行
 *
 *  @param view  显示Toast的View
 *  @param image Toast图片
 *  @param text  Toast文本
 *  @param style 外观类型
 */
+ (void)showToastInView:(UIView *)view
              withImage:(UIImage *)image
                   text:(NSString *)text
                  style:(GFToastStyle)style;

/**
 *  显示 Toast
 *
 *  @param view      显示Toast的View
 *  @param image     Toast图片
 *  @param text      Toast文本
 *  @param style     外观类型
 *  @param position  显示的位置
 *  @param duration  持续时长
 *  @param animation 动画效果
 */
+ (void)showToastInView:(UIView *)view
              withImage:(UIImage *)image
                   text:(NSString *)text
                  style:(GFToastStyle)style
               position:(GFToastShowPosition)position
               duration:(GFToastShowTime)duration
              animation:(GFToastAnimation)animation;

@end
