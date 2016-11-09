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
static const CGFloat kToastDefaultAlpha = 1.0;

// 内边距
static const CGFloat kToastPaddingLeft = 18.0;
static const CGFloat kToastPaddingTop = 12.0;

// 最大外边距
static const CGFloat kToastMarginLeft = 40.0;

// 图片固定边长
static const CGFloat kImageSideLength = 20.0;

// Toast 显示持续时长
static const CGFloat kLongShowTime = 3.6;
static const CGFloat kShortShowTime = 1.8;

// 显示与消失的动画持续时长
static const CGFloat kFadeInAnimationDuration = 0.2;
static const CGFloat kZoomInAnimationDuration = 0.15;
static const CGFloat kShakeInAnimationDuration = 0.18;
static const CGFloat kScaleInAnimationDuration = 0.08;
static const CGFloat kHideAnimationDuration = 0.25;



#pragma mark - Class Method

+ (void)showToastInView:(UIView *)view withText:(NSString *)text style:(GFToastStyle)style {
    
    // 不指定图片，默认不显示图片
    // 不指定显示位置，默认为 GFToastShowPositionBottom
    // 不指定显示时长，默认为 GFToastShowTimeShort
    // 不指定动画类型，默认为 GFToastAnimationFadeInFadeOut
    [self showToastInView:view withImage:nil text:text style:style position:GFToastShowPositionBottom duration:GFToastShowTimeShort animation:GFToastAnimationFadeInFadeOut];
    
}

+ (void)showToastInView:(UIView *)view
              withImage:(UIImage *)image
                   text:(NSString *)text
                  style:(GFToastStyle)style {
    
    // 不指定显示位置，默认为 GFToastShowPositionBottom
    // 不指定显示时长，默认为 GFToastShowTimeShort
    // 不指定动画类型，默认为 GFToastAnimationFadeInFadeOut
    [self showToastInView:view withImage:image text:text style:style position:GFToastShowPositionBottom duration:GFToastShowTimeShort animation:GFToastAnimationFadeInFadeOut];
    
}

+ (void)showToastInView:(UIView *)view
              withImage:(UIImage *)image
                   text:(NSString *)text
                  style:(GFToastStyle)style
               position:(GFToastShowPosition)position
               duration:(GFToastShowTime)duration
              animation:(GFToastAnimation)animation {
    
    GFToast *toast = [[GFToast alloc] initWithImage:image
                                               text:text
                                              style:style
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
                        style:(GFToastStyle)style
                    animation:(GFToastAnimation)animation
                     position:(GFToastShowPosition)position {
    
    if (self = [super init]) {
        
        self.clipsToBounds = YES;
        self.alpha = 0.0;
        self.layer.cornerRadius = 12.0; // 圆角
        
        _animationType = animation;
        _showPosition = position;
        
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.text = text;
        _textLabel.font = [UIFont systemFontOfSize:14.5];
        [self addSubview:_textLabel];
        
        // 根据外观类型处理外观颜色
        if (style == GFToastStyleLight) {
            self.backgroundColor = [UIColor whiteColor];
            _textLabel.textColor = [UIColor blackColor];
        } else if (style == GFToastStyleDark) {
            self.backgroundColor = [UIColor blackColor];
            _textLabel.textColor = [UIColor whiteColor];
        }

        
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

- (void)didMoveToSuperview {
    
    switch (_animationType) {
        case GFToastAnimationFadeInFadeOut:
            [self showToastFadeIn];
            break;
        case GFToastAnimationZoomInZoomOut:
            [self showToastZoomIn];
            break;
        case GFToastAnimationZoomInFadeOut:
            [self showToastZoomIn];
            break;
        case GFToastAnimationShakeInFadeOut:
            [self showToastShakeIn];
            break;
        case GFToastAnimationShakeInZoomOut:
            [self showToastShakeIn];
            break;
        case GFToastAnimationScaleInFadeOut:
            [self showToastScaleIn];
            break;
        case GFToastAnimationScaleInZoomOut:
            [self showToastScaleIn];
            break;
        default:
            break;
    }
    
}

- (void)hideToast {
    
    switch (_animationType) {
        case GFToastAnimationFadeInFadeOut:
            [self hideToastFadeOut];
            break;
        case GFToastAnimationZoomInZoomOut:
            [self hideToastZoomOut];
            break;
        case GFToastAnimationZoomInFadeOut:
            [self hideToastFadeOut];
            break;
        case GFToastAnimationShakeInFadeOut:
            [self hideToastFadeOut];
            break;
        case GFToastAnimationShakeInZoomOut:
            [self hideToastZoomOut];
            break;
        case GFToastAnimationScaleInFadeOut:
            [self hideToastFadeOut];
            break;
        case GFToastAnimationScaleInZoomOut:
            [self hideToastZoomOut];
            break;
        default:
            break;
    }
    
}


#pragma mark - Show & Hide Animation

- (void)showToastFadeIn {
    
    [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
        self.alpha = kToastDefaultAlpha;
    }];
    
}

- (void)showToastZoomIn {
    
    self.alpha = kToastDefaultAlpha;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = kZoomInAnimationDuration;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)showToastShakeIn {
    
    self.alpha = kToastDefaultAlpha;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = kShakeInAnimationDuration;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)showToastScaleIn {
    
    self.alpha = kToastDefaultAlpha;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = kScaleInAnimationDuration;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)hideToastFadeOut {
    
    [UIView animateWithDuration:kHideAnimationDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)hideToastZoomOut {
    
    [UIView animateWithDuration:kHideAnimationDuration animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
