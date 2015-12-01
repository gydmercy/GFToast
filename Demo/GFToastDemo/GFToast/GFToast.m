//
//  GFToast.m
//
//  Created by Mercy on 15/9/21.
//  Copyright (c) 2015年 Mercy. All rights reserved.
//

#import "GFToast.h"

@interface GFToast()

@property (nonatomic, strong) UILabel *textLabel; //!< 显示文字
@property (nonatomic, strong) UIImageView *imageView; // !< 显示图片

@property (nonatomic, assign) GFToastAnimation animationType;
@property (nonatomic, assign) GFToastShowTime showTime;
@property (nonatomic, assign) GFToastShowPosition showPosition;

@property (nonatomic, assign) CGSize toastSize;

@end

@implementation GFToast

// Toast 默认透明度
static const CGFloat kToastDefaultAlpha = 0.75;

// 内边距
static const CGFloat kToastPaddingLeft = 16.0;
static const CGFloat kToastPaddingTop = 10.0;

// 最大外边距
static const CGFloat kToastMarginLeft = 40.0;

// 图片固定边长
static const CGFloat kImageSideLength = 19.0;

// Toast 显示持续时长
static const CGFloat kLongShowTime = 3.2;
static const CGFloat kShortShowTime = 1.6;

// 动画持续时长
static const CGFloat kShowAnimationDuration = 0.3;
static const CGFloat kHideAnimationDuration = 0.4;


#pragma mark - Class Method

+ (void)showToastInView:(UIView *)view withText:(NSString *)text {
    
    // 不指定图片，默认不显示图片
    // 不指定显示位置，默认为 GFToastShowPositionBottom
    // 不指定显示时长，默认为 GFToastShowTimeShort
    // 不指定动画类型，默认为 GFToastAnimationFadeInFadeOut
    [self showToastInView:view withImage:nil text:text position:GFToastShowPositionBottom duration:GFToastShowTimeShort animation:GFToastAnimationFadeInFadeOut];
    
}

+ (void)showToastInView:(UIView *)view
              withImage:(UIImage *)image
                   text:(NSString *)text {
    
    // 不指定显示位置，默认为 GFToastShowPositionBottom
    // 不指定显示时长，默认为 GFToastShowTimeShort
    // 不指定动画类型，默认为 GFToastAnimationFadeInFadeOut
    [self showToastInView:view withImage:image text:text position:GFToastShowPositionBottom duration:GFToastShowTimeShort animation:GFToastAnimationFadeInFadeOut];
    
}

+ (void)showToastInView:(UIView *)view
              withImage:(UIImage *)image
                   text:(NSString *)text
               position:(GFToastShowPosition)position
               duration:(GFToastShowTime)duration
              animation:(GFToastAnimation)animation {
    
    GFToast *toast = [[GFToast alloc] initWithImage:image
                                               text:text
                                          animation:animation
                                           position:position];
    [view addSubview:toast];
    
    CGFloat timeinterval;
    if (duration == GFToastShowTimeLong) {
        timeinterval = kLongShowTime;
    } else {
        timeinterval = kShortShowTime;
    }
    
    // 持续一段时间之后隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeinterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast hideToast];
    });

}


#pragma mark - Private Method

- (instancetype)initWithImage:(UIImage *)image
                         text:(NSString *)text
                    animation:(GFToastAnimation)animation
                     position:(GFToastShowPosition)position {
    
    if (self = [super init]) {
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0;
        
        _animationType = animation;
        _showPosition = position;
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.text = text;
        _textLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_textLabel];
        
        // 根据是否带有图片，分开处理
        if (image) {
            // 有图片的话，文字不能超过一行
            _textLabel.numberOfLines = 1;
            
            _imageView = [[UIImageView alloc] initWithImage:image];
            [self addSubview:_imageView];
        
        } else {
            // 没有图片，文字可以多行
            _textLabel.numberOfLines = 0;
        }
        
    }
    
    return self;
    
}

#define kNewSuperViewSizeWidth newSuperview.frame.size.width
#define kNewSuperViewSizeHeight newSuperview.frame.size.height

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    // 计算输入文字占据的大小
    CGSize limitedSize = CGSizeMake(kNewSuperViewSizeWidth - 2 * kToastMarginLeft, 0.5 * kNewSuperViewSizeHeight);
    CGSize textSize = [_textLabel.text boundingRectWithSize:limitedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_textLabel.font} context:nil].size;
    
    // 根据是否带有图片，设置 toast 控件的 frame
    if (_imageView) {
        _toastSize.width = textSize.width + kImageSideLength + 2.6 * kToastPaddingLeft;
    } else {
        _toastSize.width = textSize.width + 2 * kToastPaddingLeft;
    }
    _toastSize.height = textSize.height + 2 * kToastPaddingTop;
    self.frame = CGRectMake(0, 0, _toastSize.width, _toastSize.height);
    
    // 显示位置
    if (_showPosition == GFToastShowPositionCenter) {
        self.center = CGPointMake(0.5 * kNewSuperViewSizeWidth, 0.5 * kNewSuperViewSizeHeight);
    } else if (_showPosition == GFToastShowPositionBottom) {
        self.center = CGPointMake(0.5 * kNewSuperViewSizeWidth, 0.8 * kNewSuperViewSizeHeight);
    } 
    
    // 圆角
    self.layer.cornerRadius = 5.0;
}

- (void)didMoveToSuperview {
    [UIView animateWithDuration:kShowAnimationDuration animations:^{
        self.alpha = kToastDefaultAlpha;
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize textLabelSize;
    textLabelSize.height = _toastSize.height - (2 * kToastPaddingTop);
    // 根据是否带有图片，设置 frame
    if (_imageView) {
        textLabelSize.width = _toastSize.width - kImageSideLength - 2.6 * kToastPaddingLeft;
        
        _imageView.frame = CGRectMake(kToastPaddingLeft, 0.5 * (_toastSize.height - kImageSideLength), kImageSideLength, kImageSideLength);
        _textLabel.frame = CGRectMake(1.6 * kToastPaddingLeft + kImageSideLength, kToastPaddingTop, textLabelSize.width, textLabelSize.height);
    } else {
        textLabelSize.width = _toastSize.width - (2 * kToastPaddingLeft);
        
        _textLabel.frame = CGRectMake(kToastPaddingLeft, kToastPaddingTop, textLabelSize.width, textLabelSize.height);
    }
    
}

- (void)hideToast {
    [UIView animateWithDuration:kHideAnimationDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
