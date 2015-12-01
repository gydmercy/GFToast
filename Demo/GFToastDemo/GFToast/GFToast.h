//
//  GFToast.h
//
//  Created by Mercy on 15/9/21.
//  Copyright (c) 2015年 Mercy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  动画类型
 */
typedef NS_ENUM(NSUInteger, GFToastAnimation){
    /** 渐隐渐现 */
    GFToastAnimationFadeInFadeOut,
    /** 缩放出现消失 */
    GFToastAnimationZoomInZoomOut
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
 *  只有文本没有图片的Toast，默认显示在底部，持续时间短，渐隐渐现
 *
 *  @param view 显示Toast的View
 *  @param text Toast文本
 */
+ (void)showToastInView:(UIView *)view
               withText:(NSString *)text;

/**
 *  既有文本又有图片的Toast，默认显示在底部，持续时间短，渐隐渐现
 *
 *  @param view  显示Toast的View
 *  @param image Toast图片
 *  @param text  Toast文本
 */
+ (void)showToastInView:(UIView *)view
              withImage:(UIImage *)image
                   text:(NSString *)text;

/**
 *  显示Toast
 *
 *  @param view      显示Toast的View
 *  @param image     Toast图片
 *  @param text      Toast文本
 *  @param position  显示的位置
 *  @param duration  持续时长
 *  @param animation 动画效果
 */
+ (void)showToastInView:(UIView *)view
              withImage:(UIImage *)image
                   text:(NSString *)text
               position:(GFToastShowPosition)position
               duration:(GFToastShowTime)duration
              animation:(GFToastAnimation)animation;

@end
